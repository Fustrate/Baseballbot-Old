module Baseballbot
  module Template
    class Gamechat
      attr_accessor :game, :post_id, :home_team, :away_team

      def initialize(template:, game:, team:, post_id:)
        @template = template
        @game = game
        @team = team
        @post_id = post_id
        @home_team = game.home_team
        @away_team = game.away_team

        @boxscore = game.boxscore

        super template: template
      end

      def home?
        @game.home_team.code == @team
      end

      def team
        home? ? home_team : away_team
      end

      def opponent
        home? ? away_team : home_team
      end

      def linescore
        lines = {
          home: {
            innings: [nil] * 9,
            runs: 0,
            hits: 0,
            errors: 0
          },
          away: {
            innings: [nil] * 9,
            runs: 0,
            hits: 0,
            errors: 0
          }
        }

        if @boxscore
          rhe = @boxscore.at_xpath '//boxscore/linescore'

          lines[:home].merge! runs: rhe['home_team_runs'].to_i,
                              hits: rhe['home_team_hits'].to_i,
                              errors: rhe['home_team_errors'].to_i

          lines[:away].merge! runs: rhe['away_team_runs'].to_i,
                              hits: rhe['away_team_hits'].to_i,
                              errors: rhe['away_team_errors'].to_i

          innings = @boxscore.xpath('//boxscore/linescore/inning_line_score')

          innings.each do |inning|
            if inning['away'] && !inning['away'].empty?
              lines[:away][:innings][inning['inning'].to_i - 1] = inning['away']

              # In case of extra innings
              lines[:home][:innings][inning['inning'].to_i - 1] = nil
            end

            if inning['home'] && !inning['home'].empty?
              lines[:home][:innings][inning['inning'].to_i - 1] = inning['home']
            end
          end
        end

        lines
      end

      def line_for(line)
        [
          "[#{ game.away_team.code }](/#{ game.away_team.code })",
          line[:innings],
          "**#{line[:runs]}**",
          "**#{line[:hits]}**",
          "**#{line[:errors]}**"
        ].flatten.join '|'
      end

      def runners
        rob = @game.linescore.at_xpath '//game/@runner_on_base_status'

        return '' unless rob

        [
          'Bases empty',
          'Runner on first',
          'Runner on second',
          'Runner on third',
          'First and second',
          'First and third',
          'Second and third',
          'Bases loaded'
        ][rob.text.to_i]
      end

      def events
        year, month, day, _ = @game.gid.split '_'
        events = []

        data = Nokogiri::XML open 'http://gd2.mlb.com/components/game/mlb/' \
                                  "year_#{year}/month_#{month}/day_#{day}/" \
                                  "gid_#{@game.gid}/inning/inning_Scores.xml"

        data.xpath('//scores/score').each do |play|
          description = play.at_xpath('*[@des and @score="T"]')['des']
                            .gsub(/[[:space:]]+/, ' ')
                            .strip

          events << {
            inning_side: play['top_inning'] == 'Y' ? 'T' : 'B',
            inning:      play['inn'],
            event:       description,
            score:       "#{play['home']}-#{play['away']}"
          }
        end

        events
      rescue
        []
      end

      def inning
        if @game.in_progress?
          begin
            @game.inning[1] + ' of the ' + @game.inning[0].to_i.ordinalize
          rescue Exception
            'Postponed'
          end
        elsif @game.over?
          'Final'
        else
          @game.status
        end
      end

      def outs
        if @game.linescore.at_xpath('//game/@outs')
          @game.linescore.xpath('//game/@outs').text.to_i
        end
      end

      def batters
        batters = {
          home: [],
          away: []
        }

        %i(home away).each do |flag|
          @boxscore.xpath("//boxscore/batting[\@team_flag='#{flag}']/batter[@bo]").each do |batter|
            batters[flag] << Batter.new(batter)
          end
        end

        batters
      end

      def pitchers
        pitchers = {
          home: [],
          away: []
        }

        %i(home away).each do |flag|
          @boxscore.xpath("//boxscore/pitching[\@team_flag='#{flag}']/pitcher").each do |pitcher|
            pitchers[flag] << Pitcher.new(pitcher)
          end
        end

        pitchers
      end

      def batter_line(batter)
        return '|||||||' unless batter

        [
          "[#{batter.name}](#{batter.url})",
          batter.pos,
          batter.ab,
          batter.r,
          batter.h,
          batter.rbi,
          batter.bb,
          batter.so,
          batter.avg
        ].join '|'
      end

      def pitcher_line(pitcher)
        # IP|H|R|ER|BB|SO|P-S|ERA

        return '|||||||' unless pitcher

        [
          "[#{pitcher.name}](#{pitcher.url})",
          pitcher.ip,
          pitcher.h,
          pitcher.r,
          pitcher.er,
          pitcher.bb,
          pitcher.so,
          "#{pitcher.pitches}-#{pitcher.strikes}",
          pitcher.era
        ].join '|'
      end

      def status
        if game.over?
          'Final'
        else
          text = ''
          text << "#{runners}, " unless runners.empty?

          text << "#{outs} #{outs == 1 ? 'Out' : 'Outs'}, "
          text << inning

          text
        end
      end

      def time_now
        tz = time_zone(@team)

        (Time.now + tz[0].hours).strftime "%-I:%M %p #{tz[1]}"
      end

      def time_zone(team)
        case team.to_sym
        when %i(COL ARI)
          [1, 'Mountain']
        when %i(HOU TEX STL KC MIN MIL CHC CWS)
          [2, 'Central']
        when %i(NYY NYM BAL WSH MIA ATL TB CLE DET BOS PHI PIT CIN TOR)
          [3, 'Eastern']
        else # %i(LAD LAA SF OAK SEA SD)
          [0, 'Pacific']
        end
      end

      def gameday
        "http://mlb.mlb.com/mlb/gameday/index.jsp?gid=#{@game.gid}"
      end

      def game_graph
        Date.today.strftime "http://www.fangraphs.com/livewins.aspx?date=%Y-%m-%d&team=#{team.name}&dh=0&season=%Y"
      end

      def strikezone_map
        Time.now.strftime "http://www.brooksbaseball.net/pfxVB/zoneTrack.php?month=%m&day=%d&year=%Y&game=gid_#{@game.gid}%2F"
      end

      def irc
        'http://webchat.freenode.net/?channels=reddit-baseball'
      end

      def live_comments
        'http://reddit-stream.com/comments/#ID#'
      end

      def player_url(id)
        "http://mlb.mlb.com/team/player.jsp?player_id=#{id}"
      end

      def home_pitcher
        pitcher_stats @game.gamecenter.xpath('//game/probables/home')
      end

      def away_pitcher
        pitcher_stats @game.gamecenter.xpath('//game/probables/away')
      end

      def pitcher_stats(node)
        format '[%{name}](%{url}) (%{wins}-%{losses}, %{era} ERA)',
               name: "#{node.xpath('useName').text} #{node.xpath('lastName').text}",
               url: player_url(node.xpath('player_id').text),
               wins: node.xpath('wins').text,
               losses: node.xpath('losses').text,
               era: node.xpath('era').text
      end

      def first_pitch
        "#{game.home_start_time} at #{game.venue}"
      end
    end
  end
end
