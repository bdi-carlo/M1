function generateRandomNumber(min_value , max_value) {
	return Math.round(Math.random() * (max_value - min_value) + min_value);
}

function generateTable() {
	let image_object = data[current_index]

	let html_table = "<table>";
	html_table += '<tr>'
	html_table += '<td>'
	html_table += '<img src="' + image_object.img + '" height="120" width="200">'
	html_table += '</td>'
	html_table += '<td>'
	html_table += '<select name="elem" id="val">'
	image_object.options.forEach(function(element) {
		if (element == image_object.answer) {
			html_table += '<option value="' + element + '">' + element + '</option>'
		} else {
			html_table += '<option value="' + element + '" selected="selected">' + element + '</option>'
		}
	});
	html_table += '</select>'
	html_table += '</td>'
	html_table += '<td>'
	html_table += '<img id="vrai" src="vrai.png" height="60" width="60" style="display: none;">'
	html_table += '<img id="faux" src="faux.png" height="60" width="60" style="display: none;">'
	html_table += '<p id="rep" style="display: none;"> la reponse est ' + image_object.answer + '</p>'
	html_table += '</td>'
	html_table += '</tr>'
	html_table += '</table>'
	document.getElementById("game_table").innerHTML = html_table;
}

function checkAnswer() {
	image_object = data[current_index]

	var e = document.getElementById("val");
	user_answer = e.options[e.selectedIndex].value;

	if (user_answer == image_object.answer) {
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
		current_index = 0;
		score = 0;
		document.getElementById("answer").innerHTML = 'Réponse fausse !';
		generateTable();
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

let image1 = {img:'bus.jpg', options:['Bus','Train','Velo'], answer:'Bus'}
let image2 = {img:'courir.jpg', options:['Parler','Danser','Courir'], answer:'Courir'}
let image3 = {img:'manger.jpg', options:['Lire','Boire','Manger'], answer:'Manger'}
let image4 = {img:'telephone.jpg', options:['Bus','Telephone','Velo'], answer:'Telephone'}
let image5 = {img:'voiture.jpg', options:['Voiture','Bus','Avion'], answer:'Voiture'}

let data = [image1, image2, image3, image4, image5]
let current_index = 0

let score = 0;
let win_score = 4;

let operations = ['+', '-'];

let selected_level = 'easy';

window.onload = generateTable;

