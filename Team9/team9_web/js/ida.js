 var temp=[100,200,300,400,500,0];
 var old = [-1,-1,-1,-1,-1];
 var mode = 1;
 $(function(){
    csmapi.set_endpoint ('http://140.113.199.200:9999');
    var profile = {
        'dm_name': 'Team9_website',          
        'idf_list':[Team9_random],
        'odf_list':[Team9_chatbot],			
    };
	
	var botui = new BotUI('botui-app');
    
    function Team9_random(res){
        for(var i =0;i<5;i++){
            if (temp[i]==500) temp[i] = 100;
            else temp[i]  = temp[i]+100;
        }
		
		temp[5] = mode;
        return temp;
    }
    
    function Team9_chatbot(data){
		showLedInfo(data);
    }
    
    function Team9_led_sync(data){
        if (data[0] == 0 || data[0] == 1 || data[0] == 2 || data[0] == 3 || data[0] == 4 || data[0] == 5) {
            mode = data[0];
        }
    }

    botui.message.bot('LED INFO');
	//CommandButtons();
	TextBox();


    var showLedInfo = function (data) { 
		//CommandButtons();
		//TextBox();
        var str_bright = "";
        var str_dark = "";
        for(var i = 0;i<data[0].length;i++){
            if (data[0][i]<=300 && (old[i] >300 || old[i]==-1)) {
                str_dark = str_dark + "LED" + " " + (i+1) + ",";
            }
            else if(data[0][i]>300 && (old[i] <=300 || old[i]==-1)) {
                str_bright = str_bright + "LED" + " " + (i+1) + ",";
            }
        }
        
        if (str_bright != "") {
            str_bright = str_bright.slice(0, -1);
            botui.message.bot({
                loading: true,
                delay: 500,
                content: str_bright + " is bright!!"
            });
        }
        if (str_dark != "") {
            str_dark = str_dark.slice(0, -1);
            botui.message.bot({
                loading: true,
                delay: 500,
                content: str_dark + " is dark!!"
            });
        }

        //Update data to the old array
        for(var i = 0;i<data[0].length;i++){
            old[i] = data[0][i];
        }
    }
	
    //Control the button of each input sentence
	function CommandButtons(){
		botui.action.button({
		autoHide: false,
		addMessage: false,
		action: [
			{
				text: 'Clear',
				value: 'clear'
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
			}
		]
		}).then(function (res) { // will be called when a button is clicked.
			if(res.value == 'clear') {
				botui.message.removeAll({});
                botui.message.bot('LED INFO');
			}
			else if(res.value == '0'){
				botui.message.add({
					human: true,
					content: '0'
				});
				mode = res.value;
			}
			else if(res.value == '1'){
				botui.message.add({
					human: true,
					content: '1'
				});
				mode = res.value;
			}
			else if(res.value == '2'){
				botui.message.add({
					human: true,
					content: '2'
				});
				mode = res.value;
			}
			else if(res.value == '3'){
				botui.message.add({
					human: true,
					content: '3'
				});
				mode = res.value;
			}
			else if(res.value == '4'){
				botui.message.add({
					human: true,
					content: '4'
				});
				mode = res.value;
			}
			else if(res.value == '5'){
				botui.message.add({
					human: true,
					content: '5'
				});
				mode = res.value;
			}
		});
	}
	
	//Control the input textbox
    function TextBox(){
		botui.action.text({
		autoHide: false,
		action: {
			button: {
            icon: 'check',
            label: 'Submit'
          },
		placeholder: 'Enter your command'

		}
		}).then(function (res) { // will be called when it is submitted.
			if(res.value.toLowerCase() == 'clear') {
				botui.message.removeAll({
				}).then();
			}
			else if(res.value == '0'){
				if (mode != '0'){
					
				
				mode = res.value;
					botui.message.add({
					human: true,
					content: 'Mode changed to 0'
				})
				}
				else{
					botui.message.add({
					human: true,
					content: 'Mode is already 0'
				})
				}
			}
			else if(res.value == '1'){
				mode = res.value;
					botui.message.add({
					human: true,
					content: 'Mode changed to 1'
				})
			}
			else if(res.value == '2'){
				mode = res.value;
					botui.message.add({
					human: true,
					content: 'Mode changed to 2'
				})
			}
			else if(res.value == '3'){
				mode = res.value;
					botui.message.add({
					human: true,
					content: 'Mode changed to 3'
				})
			}
			else if(res.value == '4'){
				mode = res.value;
					botui.message.add({
					human: true,
					content: 'Mode changed to 4'
				})
			}
			else if(res.value == '5'){
				mode = res.value;
				botui.message.add({
					human: true,
					content: 'Mode changed to 5'
				})
			}
			else{
				botui.message.add({
					human: true,
					content: 'Invalid Command'
				})
			}
        }).then(TextBox);
    }
/*******************************************************************/                
    function ida_init(){}
    var ida = {
        'ida_init': ida_init,
    }; 
    dai(profile,ida);  



    

    

    
});
