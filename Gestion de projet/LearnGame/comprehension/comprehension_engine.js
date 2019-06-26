function generateRandomNumber(min_value , max_value) {
	return Math.round(Math.random() * (max_value - min_value) + min_value);
}

function generateTable() {
	let current_object = data[current_index]

	let html_table = '<p>' + current_object.sentence + '</p>'
	html_table += "<table>";
	html_table += '<tr>'
	current_object.options.forEach(function(element) {
		html_table += '<td>'
		html_table += '<img src="' + element + '.jpg" width=\'120px\' height=\'120px\'/>'
		html_table += '</td>'
	});
	html_table += '</tr>'
	html_table += '<tr>'
	html_table += '<td>'
	html_table += '<p>1</p>'
	html_table += '</td>'
	html_table += '<td>'
	html_table += '<p>2</p>'
	html_table += '</td>'
	html_table += '<td>'
	html_table += '<p>3</p>'
	html_table += '</td>'
	html_table += '</tr>'
	html_table += '</table>'
	html_table += '<form>'
  	html_table += 'Quelle image est correcte?<br>'
 	html_table += '<input type="radio" name="colors" id="1">1<br>'
  	html_table += '<input type="radio" name="colors" id="2">2<br>'
  	html_table += '<input type="radio" name="colors" id="3">3'
	html_table += '</form>'
	document.getElementById("game_table").innerHTML = html_table;
}

function checkAnswer() {
	image_object = data[current_index]

	user_answer = document.getElementById(image_object.answer).checked;

	if (user_answer) {
		score += 1
		document.getElementById("answer").innerHTML = '';
		if (score == win_score) {
			alert('VOUS AVEZ GAGNE !!');
		} else {
			current_index += 1
			if (current_index > data.length) {
				alert('You saw all images')
			} else {
				generateTable()
			}
		}
	} else {
		current_index = 0
		score = 0
		document.getElementById("answer").innerHTML = 'Réponse fausse !';
		generateTable()
	}
	document.getElementById("score").innerHTML = score
}

function revealAnswer() {
	document.getElementById("answer").innerHTML = 'La réponse est ' + answer;
}

function levelIsChanged() {
	let level_e = document.getElementById("level");
	selected_level = level_e.options[level_e.selectedIndex].value;

	if (level == 'easy') {

	} else {

	}

	score = 0

	generateTable()
}

let object1 = {sentence:"C'est un fruit rouge, il a de petites graines et sa chaire est juteuse", options:['fraise-cerise','fraise-good','fraise-pomme'], answer:2}
let object2 = {sentence:"C'est un moyen de transport, il a 4 roues et peut transporter 5 personnes", options:['voiture-good','voiture-bus','voiture-velo'], answer:1}
let object3 = {sentence:"C'est un objet transparent, circulaire et que l'on utilise pour boire", options:['verre-good','verre-table','verre-rideau'], answer:1}
let object4 = {sentence:"C'est un animal qui a 4 pattes, il est carnivore et vit dans la savane", options:['lion-good','lion-chien','lion-chat'], answer:1}

let data = [object1, object2, object3, object4]
let current_index = 0

let score = 0;
let win_score = 4;

let selected_level = 'easy';

window.onload = generateTable;
