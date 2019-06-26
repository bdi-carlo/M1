function generateRandomNumber(min_value , max_value) {
	return Math.round(Math.random() * (max_value - min_value) + min_value);
}

function generateTable() {
	let html_table = "<table>";
	html_table += "<tr>";
	for (let i = 0; i < number_top_objects; i++) {
	    html_table += "<td class='object'></td>";
	}
	html_table += "</tr>";
	if (operation == "+") {
		html_table += "<tr><td class='plus'></td></tr>";
	} else {
		html_table += "<tr><td class='moins'></td></tr>";
	}
	html_table += "<tr>";
	for (let i = 0; i < number_bottom_objects; i++) {
	    html_table += "<td class='object'></td>";
	}
	html_table += "</tr>";
	html_table += "</table>";
	html_table += '<br>'
	html_table += '<input type="text" name="user_answer" value="" placeholder=\'Réponse\'>'
	html_table += '<br>'
	html_table += '<button id="btnTable" onclick="checkAnswer()">Répondre</button>'
	html_table += '<button id="btnTable" onclick="revealAnswer()">Voir réponse</button>'
	document.getElementById("game_table").innerHTML = html_table;
}

function checkAnswer() {
	user_answer = document.getElementsByName("user_answer")[0].value
	if (user_answer == answer) {
		score += 1
		document.getElementById("answer").innerHTML = '';
		if (score == win_score) {
			alert('VOUS AVEZ GAGNE !!');
			score = 0
		}
		generateValues()
		generateTable()
	} else {
		score -= 1
		document.getElementById("answer").innerHTML = 'Réponse fausse !';
	}
	document.getElementById("score").innerHTML = score
}

function revealAnswer() {
	document.getElementById("answer").innerHTML = 'La réponse est ' + answer;
}

function generateValues() {
	number_top_objects = generateRandomNumber(min_value, max_value);
	number_bottom_objects = generateRandomNumber(min_value, max_value);
	operation = operations[generateRandomNumber(0, 1)];

	if (level == 'easy' && operation == '-') {
		if (number_bottom_objects > number_top_objects) {
			temp = number_top_objects
			number_top_objects = number_bottom_objects
			number_bottom_objects = temp
		}
	}

	if (operation == '+') {
		answer = number_top_objects + number_bottom_objects
	} else if (operation == '-') {
		answer = number_top_objects - number_bottom_objects
	}

	console.log(number_top_objects);
	console.log(number_bottom_objects);
	console.log(operation);
	console.log(answer);
}

function levelIsChanged() {
	let e = document.getElementById("level");
	level = e.options[e.selectedIndex].text;

	score = 0
	document.getElementById("score").innerHTML = score

	if (level == 'easy') {
		min_value = 1
		max_value = 5
	} else {
		min_value = 1
		max_value = 9
	}

	generateValues()
	generateTable()
}

let level = "easy"

let score = 0
let win_score = 4

let min_value = 1;
let max_value = 5;

let answer = 0

let operations = ['+', '-'];

let number_top_objects = 0
let number_bottom_objects = 0
let operation = ''

generateValues()

window.onload = generateTable;
