 $(function(){
        set_endpoint('http://140.113.199.198:9992');
		set_PUSH_INTERVAL(500);
		
        var profile = {
		    'dm_name': '0416106',          
			'idf_list':[],
			'odf_list':[[_0416106,['None']]],			
        };
		
        /*
        function Dummy_Sensor(){
            return Math.random();
        }
        */
		
        function _0416106(data){
            $('.ODF_value')[0].innerText=data[0];
        }
      
/*******************************************************************/                
        function ida_init(){console.log('Success.');}
        var ida = {
            'ida_init': ida_init,
        }; 
        dai(profile,ida);     
});
