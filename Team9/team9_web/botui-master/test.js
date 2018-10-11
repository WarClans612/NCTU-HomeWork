var botui = new BotUI('botui-app');
var	inputtext = {};
var mode;

function InitializeChat(){
botui.message
  .bot('led info')
  .then(function () {
	//CommandButtons();
	TextBox();	
    showLedInfo();
	//CheckText();
	//TextBox();
	//CheckText();
});
}

var showLedInfo = function () {
  botui.message
    .bot({
	  delay: 1000,
	  loading: true,
	  //human: true,
      content: 'too bright'
    }).then(showLedInfo);
}

InitializeChat();


var CommandButtons = function(){
	botui.action.button({
		autoHide: false,
		//addMessage: false,
		action: [
			{
			text: 'Clear',
			value: 'Clear',
			command:  'Clear'
			},
			{
			text: '0',
			value: '0'
			},
			{
			text: '1',
			value: '1'
			},
			{
			text: '2',
			value: '2'
			},
			{
			text: '3',
			value: '3'
			},
			{
			text: '4',
			value: '4'
			},
			{
			text: '5',
			value: '5'
			},
		]
		}).then(function (res) { // will be called when a button is clicked.
			//botui.message.removeAll({
			console.log(res.value);
			CheckText();
		//}).then(InitializeChat);
		//)}.then(CheckText());
	});
	
}

function CheckText(){
	//inputtext = value
	if (value == 'clear'){
		botui.message.removeAll({
		
		}).then();
	}
}

function TextBox(){
	botui.action.text({
	autoHide: false,
	action: {
    placeholder: 'Enter your command'
	}
}).then(function (res) { // will be called when it is submitted.
	if(res.value == 'clear') {
				botui.message.removeAll({
				}).then();
			}
			else if(res.value == '0'){
				botui.message.add({
					human: true,
					content: '0'
				}).then();
				mode = res.value;
			}
			else if(res.value == '1'){
				botui.message.add({
					human: true,
					content: '1'
				}).then();
				mode = res.value;
			}
			else if(res.value == '2'){
				botui.message.add({
					human: true,
					content: '2'
				}).then();
				mode = res.value;
			}
			else if(res.value == '3'){
				botui.message.add({
					human: true,
					content: '3'
				}).then();
				mode = res.value;
			}
			else if(res.value == '4'){
				botui.message.add({
					human: true,
					content: '4'
				}).then();
				mode = res.value;
			}
			else if(res.value == '5'){
				botui.message.add({
					human: true,
					content: '5'
				}).then();
				mode = res.value;
			}
});
}