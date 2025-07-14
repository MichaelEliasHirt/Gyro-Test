extends Control

func set_score(score:int):
	$Box/WellDone/ScoreLabel.text = "Score: " + str(score)
	
func set_highscore(score:int):
	$Box/WellDone/HighscoreLabel.text = "Best: " + str(score)
