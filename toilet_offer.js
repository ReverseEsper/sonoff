/* 
    Task is to monitor state of Bathrooms lights every n seconds and when they are on for longer than m minutes, turn them off
*/
const ewelink = require('ewelink-api');

var licznik = 0

const connection = new ewelink({
    email: 'adam.kurowski.ewelink@darevee.pl',
    password: '3ESCAFLONE',
    region: 'us',
  });

async function turn_of_lights () {
    const power_state_1 =  await connection.getDevicePowerState('100050403b',1);
	const power_state_2 = await connection.getDevicePowerState('100050403b',2);
    if ((power_state_1.state == 'on')||(power_state_2.state == 'on')) {
        licznik ++;
        if (licznik > 15 ) {
            await connection.setDevicePowerState('100050403b','off',1);
	        await connection.setDevicePowerState('100050403b','off',2);
            licznik = 0;
        }
    }
    
}



setInterval(turn_of_lights,60*1000);
