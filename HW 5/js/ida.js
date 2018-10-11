 $(function(){
        csmapi.set_endpoint ('http://140.113.199.205:9999');
        var profile = {
		    'dm_name': '0416106',          
			'idf_list':[],
			'odf_list':[_0416106],			
        };
		
        function Dummy_Sensor(){
            return Math.random();
        }
		
        function _0416106(data){
            if (data[0][2] > 0) {
                $('.ODF_value')[0].innerText= "Smartphone facing up";
            }
            else {
                $('.ODF_value')[0].innerText= "Smartphone facing down";
            }
        }
      
/*******************************************************************/                
        function ida_init(){}
        var ida = {
            'ida_init': ida_init,
        }; 
        dai(profile,ida);     
});
