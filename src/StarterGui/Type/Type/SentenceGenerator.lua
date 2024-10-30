-- // sentencesGenerator.Randomize() --> Random Sentence (string)
local sentences = {
	past = {
		p1 = {
			"I was";
			"He was";
			"She was";
			"They were";
			"We were";
		};
		
		p2 = {
			"riding a roller coaster";
			"cooking dinner";
			"doing cardio";
			"playing video games";
			"eating lunch";
			"studying for a test";
			"programming an upcoming game";
			"running a marathon";
		};
		
		p3 = {
			"yesterday evening";
			"a couple of hours ago";
			"earlier today";
			"an hour ago";
			"over a year ago";
			"not so long ago";
			"some long time ago"
		};
	};
	
	present = {
		p1 = {
			"I am";
			"He is";
			"She is";
			"They are";
			"We are";
		};

		p2 = {
			"running";
			"running a marathon";
			"climbing tall mountains";
			"programming a game";
			"learning muscle ups";
			"unavailable";
			"not doing the dishes";
			"doing homework";
			"attempting to wake him up";
			"eating my breakfast";
		};
		
		p3 = {
			"at the moment";
			"right now";
			"now";
			"presently";
			"at this juncture";
		};
	};
	
	future = {
		p1 = {
			"I will";
			"He will";
			"She will";
			"They will";
			"We will";
		};

		p2 = {
			"start working out";
			"do mathematics";
			"behave better";
			"help you";
			"talk to you";
			"see you again";
		};
		
		p3 = {
			"once there is an opportunity";
			"soon";
			"next time";
			"sooner or later";
			"one day";
		};
	};
};

local sentencesGenerator = {}
function sentencesGenerator.Randomize()
	local chosenTime = math.random(1, 3);
	if (chosenTime == 1) then
		chosenTime = sentences["past"]
	elseif (chosenTime == 2) then
		chosenTime = sentences["present"]
	elseif (chosenTime == 3) then
		chosenTime = sentences["future"]
	end;
	
	local sentence = string.format("%s %s %s.",
		chosenTime["p1"][math.random(1, #chosenTime["p1"])], 
		chosenTime["p2"][math.random(1, #chosenTime["p2"])],
		chosenTime["p3"][math.random(1, #chosenTime["p3"])]
	)
	
	return (sentence);
end;

return sentencesGenerator