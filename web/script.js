const container = document.querySelector('.container')
const kills = document.querySelector('.kills span');
const deaths = document.querySelector('.deaths span');
const kd = document.querySelector('.kd span');

function updateValues(data) {
    kills.textContent = data.kills
    deaths.textContent = data.deaths
    
    const ratio = data.deaths === 0 ? data.kills : (data.kills/data.deaths);
    kd.textContent = ratio.toFixed(2)
}

window.addEventListener('message', function(event) {
    switch (event.data.type) {
        case 'showUI':
            container.style.display = 'block';
            break;
            
        case 'hideUI':
            container.style.display = 'none';
            break;

        case 'update':
            updateValues(event.data.values);
            break;
    }
});

