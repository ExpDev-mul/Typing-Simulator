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
			"absolutely fascinated by the night skies lately.";
			"very sad in comparison to the opponents.";
			"late to class, therefore I missed it."
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
			"often using very illogical arguments to shift the topic.";
			"extremely tired because of the long road trip.";
			"irregularly intelligent."
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
			"make sure to consider the consequences.";
			"definitely be late, the roads are extremely busy!";
			"start practicing for the mathematics test in a day or two.";
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
	
	local sentence = string.format("%s %s",
		chosenTime["p1"][math.random(1, #chosenTime["p1"])], 
		chosenTime["p2"][math.random(1, #chosenTime["p2"])]
	)
	
	return (sentence);
end;

return sentencesGenerator