const ewelink = require('ewelink-api');

/* instantiate class */
const connection = new ewelink({
  email: 'adam.kurowski.ewelink@darevee.pl',
  password: '3ESCAFLONE',
  region: 'us',
});

/* get all devices */
(async() => {
	//const devices = await connection.getDevices();
	//console.log(devices); 
	//for (const element in devices) {
	//	console.log(`${devices[element]._id} : ${devices[element].name}`)
	//} 

        //const lazienka = await connection.getDevice('100050403b');
	//console.log(lazienka); 
	const power_state_1 = await connection.getDevicePowerState('100050403b',1);
	const power_state_2 = await connection.getDevicePowerState('100050403b',2);
	console.log(power_state_1)
	console.log(power_state_2)
	//await connection.setDevicePowerState('100050403b','off',1);
	//await connection.setDevicePowerState('100050403b','off',2);
	const usage = await connection.getDevicePowerUsage('100050403b');
	console.log(usage)
})();
