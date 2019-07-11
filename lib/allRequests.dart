 import 'dart:collection';

List<List<String>> allRequests1 = [
 ['7ec', '24', '31', '1', '40', '0', '°C', '222001', '622001', 'ff', 'Battery Rack temperature'],
 ['7ec', '24', '39', '.02', '0', '0', '%', '222002', '622002', 'ff', 'State Of Charge (SOC) HV battery'],
 ['7ec', '24', '39', '.01', '0', '0', 'km/h', '222003', '622003', 'ff', 'Vehicle speed'],
 ['7ec', '24', '47', '1', '0', '0', 'km', '222006', '622006', 'ff', 'Total vehicle distance'],
 ['7ec', '31', '31', '1', '0', '0','',  '22200E', '62200E', 'ff', 'Key state', '0:key off;1:key on'],
 ['7ec', '31', '31', '1', '0', '0', '', '222051', '622051', 'ff', 'Displayed vehicle speed unit', '0:km/h;1:mph'],
 ['7ec', '24', '31', '1', '40', '0', '°C', '223307', '623307', 'ff','Heat water temperature'],
 ['7ec', '24', '31', '1', '0', '0','', '2234CF', '6234CF', 'ff', 'Power consumed by the 400V components for Thermal Comfort' ],
 ['7ec', '24', '47', '.0000000762', '-1', '0', 'kWh/km', '223478', '623478', 'ff', 'Raw mean consumption per unit of distance'],
 ['7ec', '24', '39', '1', '-1', '0', 'kW', '223459', '623459', 'ff','Mean consumption per unit of distance,  used for calculation of kilometric range'],
 ['7ec', '24', '39', '1', '-1', '0', 'kW', '223457', '623457', 'ff', 'Mean pessimistic electrical consumption (worst possible consumption)'],
 ['7ec', '24', '39', '1', '0', '0', 'km', '223456', '623456', 'ff', 'Temporary estimated kilometric cruising range sent to MMI (economical driving)'],
 ['7ec', '24', '39', '1', '-1', '0', 'kW', '223455', '623455', 'ff','Mean eco electrical consumption (if driver has economical driving behavior)'],

 ['7ec', '24', '47', '.001', '0', '0', 'kW', '223454', '623454', 'ff', 'Contributions of anticipation lack and excessive vehicle speed to electrical overconsumption since cluster reset.1'],
 ['7ec', '48', '71', '.001', '0', '0', 'kW', '223454', '623454', 'ff', 'Contributions of anticipation lack and excessive vehicle speed to electrical overconsumption since cluster reset.0'],

   ['7ec', '24', '39', '1', '0','0', 'km', '223451', '623451', 'ff', 'Estimated kilometric cruising range sent to MMI'],
 ['7ec', '24', '39', '1', '0','0', 'km', '223458', '623458', 'ff', 'Temporary estimated minimum kilometric cruising range sent to MMI'],
 ['7ec', '24', '3','1', '25', '0', '0', 'W', '2233A7', '6233A7', 'ff', 'AC compressor Power Consumption Estimation'],

   ['7ec', '168', '183', '.01', '0', '0', 'kWh', '223414', '623414', 'ff', 'Memorized accumutation of the energy used by the thermal comfort for energy consumption journal.0'],


 ];

Map<String,List<String>> allRequests = {
'622001':['7ec', '24', '31', '1', '40', '0', '°C', '222001', '622001', 'ff', 'Battery Rack temperature'],
'622002':['7ec', '24', '39', '.02', '0', '0', '%', '222002', '622002', 'ff', 'State Of Charge (SOC) HV battery'],
'622003':['7ec', '24', '39', '.01', '0', '0', 'km/h', '222003', '622003', 'ff', 'Vehicle speed'],
'622006': ['7ec', '24', '47', '1', '0', '0', 'km', '222006', '622006', 'ff', 'Total vehicle distance'],
'62200E': ['7ec', '31', '31', '1', '0', '0','',  '22200E', '62200E', 'ff', 'Key state', '0:key off;1:key on'],
'622051':  ['7ec', '31', '31', '1', '0', '0', '', '222051', '622051', 'ff', 'Displayed vehicle speed unit', '0:km/h;1:mph'],
'623307':  ['7ec', '24', '31', '1', '40', '0', '°C', '223307', '623307', 'ff','Heat water temperature'],
'6234CF': ['7ec', '24', '31', '1', '0', '0','', '2234CF', '6234CF', 'ff', 'Power consumed by the 400V components for Thermal Comfort' ],
'623478': ['7ec', '24', '47', '.0000000762', '-1', '0', 'kWh/km', '223478', '623478', 'ff', 'Raw mean consumption per unit of distance'],
'623459':  ['7ec', '24', '39', '1', '-1', '0', 'kW', '223459', '623459', 'ff','Mean consumption per unit of distance,  used for calculation of kilometric range'],
'623457':  ['7ec', '24', '39', '1', '-1', '0', 'kW', '223457', '623457', 'ff', 'Mean pessimistic electrical consumption (worst possible consumption)'],
'623456': ['7ec', '24', '39', '1', '0', '0', 'km', '223456', '623456', 'ff', 'Temporary estimated kilometric cruising range sent to MMI (economical driving)'],
'623455': ['7ec', '24', '39', '1', '-1', '0', 'kW', '223455', '623455', 'ff','Mean eco electrical consumption (if driver has economical driving behavior)'],

'623454': ['7ec', '24', '47', '.001', '0', '0', 'kW', '223454', '623454', 'ff', 'Contributions of anticipation lack and excessive vehicle speed to electrical overconsumption since cluster reset.1'],
'623454':  ['7ec', '48', '71', '.001', '0', '0', 'kW', '223454', '623454', 'ff', 'Contributions of anticipation lack and excessive vehicle speed to electrical overconsumption since cluster reset.0'],

'623451':  ['7ec', '24', '39', '1', '0','0', 'km', '223451', '623451', 'ff', 'Estimated kilometric cruising range sent to MMI'],
'623458': ['7ec', '24', '39', '1', '0','0', 'km', '223458', '623458', 'ff', 'Temporary estimated minimum kilometric cruising range sent to MMI'],
'6233A7': ['7ec', '24', '3','1', '25', '0', '0', 'W', '2233A7', '6233A7', 'ff', 'AC compressor Power Consumption Estimation'],

'623414': ['7ec', '168', '183', '.01', '0', '0', 'kWh', '223414', '623414', 'ff', 'Memorized accumutation of the energy used by the thermal comfort for energy consumption journal.0']
};


