require_relative './connection'
require_relative './classes'
require 'json'
require 'httparty'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'gruff'

nba_champions={}
nba_champions[:blazers1977]=Blazers1977.all
nba_champions[:bullets1978]=Bullets1978.all
nba_champions[:sonics1979]=Sonics1979.all
nba_champions[:lakers1980]=Lakers1980.all
nba_champions[:celtics1981]=Celtics1981.all
nba_champions[:lakers1982]=Lakers1982.all
nba_champions[:seventysixers1983]=Seventysixers1983.all
nba_champions[:celtics1984]=Celtics1984.all
nba_champions[:lakers1985]=Lakers1985.all
nba_champions[:celtics1986]=Celtics1986.all
nba_champions[:lakers1987]=Lakers1987.all
nba_champions[:lakers1988]=Lakers1988.all
nba_champions[:pistons1989]=Pistons1989.all
nba_champions[:pistons1990]=Pistons1990.all
nba_champions[:bulls1991]=Bulls1991.all
nba_champions[:bulls1992]=Bulls1992.all
nba_champions[:bulls1993]=Bulls1993.all
nba_champions[:rockets1994]=Rockets1994.all
nba_champions[:rockets1995]=Rockets1995.all
nba_champions[:bulls1996]=Bulls1996.all
nba_champions[:bulls1997]=Bulls1997.all
nba_champions[:bulls1998]=Bulls1998.all
nba_champions[:spurs1999]=Spurs1999.all
nba_champions[:lakers2000]=Lakers2000.all
nba_champions[:lakers2001]=Lakers2001.all
nba_champions[:lakers2002]=Lakers2002.all
nba_champions[:spurs2003]=Spurs2003.all
nba_champions[:pistons2004]=Pistons2004.all
nba_champions[:spurs2005]=Spurs2005.all
nba_champions[:heat2006]=Heat2006.all
nba_champions[:spurs2007]=Spurs2007.all
nba_champions[:celtics2008]=Celtics2008.all
nba_champions[:lakers2009]=Lakers2009.all
nba_champions[:lakers2010]=Lakers2010.all
nba_champions[:mavericks2011]=Mavericks2011.all
nba_champions[:heat2012]=Heat2012.all
nba_champions[:heat2013]=Heat2013.all
nba_champions[:spurs2014]=Spurs2014.all


after do
    ActiveRecord::Base.connection.close
end
 	teams=[ "1977 Blazers", "1978 Bullets", "1979 Sonics", "1980 Lakers", "1981 Celtics", "1982 Lakers", "1983 76ers", "1984 Celtics", "1985 Lakers", "1986 Celtics", "1987 Lakers", "1988 Lakers", "1989 Pistons", "1990 Pistons", "1991 Bulls", "1992 Bulls", "1993 Bulls", "1994 Rockets", "1995 Rockets", "1996 Bulls", "1997 Bulls", "1998 Bulls", "1999 Spurs", "2000 Lakers", "2001 Lakers", "2002 Lakers", "2003 Spurs", "2004 Pistons", "2005 Spurs", "2006 Heat", "2007 Spurs", "2008 Celtics", "2009 Lakers", "2010 Lakers", "2011 Mavericks", "2012 Heat", "2013 Heat", "2014 Spurs"]
	team_sym=["blazers1977" , "bullets1978", "sonics1979", "lakers1980", "celtics1981", "lakers1982", "seventysixers1983", "celtics1984", "lakers1985", "celtics1986", "lakers1987", "lakers1988", "pistons1989", "pistons1990", "bulls1991", "bulls1992", "bulls1993", "rockets1994", "rockets1995", "bulls1996", "bulls1997", "bulls1998", "spurs1999", "lakers2000", "lakers2001", "lakers2002", "spurs2003", "pistons2004", "spurs2005", "heat2006", "spurs2007", "celtics2008", "lakers2009", "lakers2010", "mavericks2011", "heat2012", "heat2013", "spurs2014"]

 get ("/") do
 	games=(1..82).to_a

 	erb(:index, {locals:{teams: teams, team_sym: team_sym, games: games}})
 end

 post("/teamcomparisons") do
 	team1=params[:team1]
 	team2=params[:team2]
 	games=params[:games].to_i
 	all=params[:all]
 	if all=="all"
 		
 		graph_wins = Gruff::Bar.new(800)
		graph_wins.title = "All Teams Wins Over #{games} Games"
		graph_wins.title_font_size = 15
		
		graph_wins.legend_font_size = 11
		graph_wins.y_axis_increment = 4
		graph_wins.theme = {
       :colors => ['#FFFB87', '#878BFF', '#292B6B', '#6B6929', '#54E381', '#E354B6', '#7D6A00', '#898DA3','##0000FF', '#FAEBD7', '#00FFFF', '#7FFFD4', '#8A2BE2', '#A52A2A', '#DEB887', '#5F9EA0', '#7FFF00', '#D2691E', '#6495ED', '#DC143C', '#00008B', '#008B8B', '#B8860B', '#A9A9A9', '#006400', '#FF8C00', '#8B0000' '#E9967A', '#8FBC8F', '#483D8B', '#00CED1', '#FF1493', '#1E90FF', '#FF00FF', '#DAA520', '#ADFF2F', '#CD5C5C', '#4B0082', '#F08080'],
       :marker_color => '#aaa',
       :background_colors => '#fff'
     }

     	if(games > 50)
     		teams.delete("1999 Spurs")
     		team_sym.delete("spurs1999")
     	end
     	if(games > 66)
     		teams.delete("2012 Heat")
     		team_sym.delete("heat2012")
     	end
		
     	info_output=[]
 		team_sym.each_with_index do |champion, index|
 		 	champ=champion.to_sym
 		 	total_wins=nba_champions[champ].find_by(game: games)
 			total_wins=total_wins[:wins]
			graph_wins.data "#{teams[index]}" , total_wins
			info_output.push("#{teams[index]} - #{total_wins} wins")

 		 end
 		 graph_wins.write("./public/all_#{games}.png")
 		 graph_name="all_#{games}.png"
 		 
 	else

 		if(games > 50)

 		
 	  		if(team1=="spurs1999")
 	  			
 	  			redirect "/error"
 				
 			elsif(team2=="spurs1999")
 				redirect "/error"
 			end
 		end
 		if(games > 66)
 			if(team1=="heat2012")
 				redirect "/error"
 			elsif(team2=="heat2012")
 				redirect "/error"
 			end
 		end
 		team1_index=team_sym.find_index(team1)
 		team2_index=team_sym.find_index(team2)
 		team1_sym=team1.to_sym
 		team2_sym=team2.to_sym
 		graph_wins = Gruff::Line.new(2000)
 		graph_wins.title = "#{teams[team1_index]} vs #{teams[team2_index]} Wins Over #{games} Games"
		graph_wins.hide_dots=true
		graph_wins.theme_pastel
		graph_wins.title_font_size = 15
 		games_array=(1..games).to_a

 		team1_wins=[]
 		team2_wins=[]
 		team1_total_wins=nba_champions[team1_sym].find_by(game: games)
 		team2_total_wins=nba_champions[team2_sym].find_by(game: games)
 		team1_total_wins=team1_total_wins[:wins]
 		team2_total_wins=team2_total_wins[:wins]
 		info_output=["#{teams[team1_index]} - #{team1_total_wins} wins", "#{teams[team2_index]} - #{team2_total_wins} wins"]

 		games_array.each do |game|
 			wins_team1=nba_champions[team1_sym].find_by(game: game)
 			wins_team1=wins_team1[:wins]
 			team1_wins.push(wins_team1)
 			wins_team2=nba_champions[team2_sym].find_by(game: game)
 			wins_team2=wins_team2[:wins]
 			team2_wins.push(wins_team2)

 		end
 		graph_wins.data "#{teams[team1_index]}" , team1_wins
 		graph_wins.data "#{teams[team2_index]}" , team2_wins
 		graph_wins.write("./public/#{teams[team1_index]}#{teams[team2_index]}#{games}.png")
 		graph_name="#{teams[team1_index]}#{teams[team2_index]}#{games}.png"


 		
 	end


 erb(:team_comparison, {locals:{graph_name: graph_name, info_output: info_output}})
end
 get("/teamcomparisons") do
 	redirect "/"
 end
 get("/error") do
 	erb(:error_page)
 end
































