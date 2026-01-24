const container = document.querySelector('.container');
const killsValue = document.querySelector('.kills-value');
const deathsValue = document.querySelector('.deaths-value');
const kdValue = document.querySelector('.kd-value');

function animateValue(element) {
    element.classList.add('updating');
    setTimeout(() => element.classList.remove('updating'), 300);
}

function updateValues(data) {
    // Update kills
    if (killsValue.textContent !== String(data.kills)) {
        killsValue.textContent = data.kills;
        animateValue(killsValue);
    }
    
    // Update deaths
    if (deathsValue.textContent !== String(data.deaths)) {
        deathsValue.textContent = data.deaths;
        animateValue(deathsValue);
    }
    
    // Calculate and update K/D ratio
    const ratio = data.deaths === 0 ? data.kills : (data.kills / data.deaths);
    const formattedRatio = ratio.toFixed(2);
    
    if (kdValue.textContent !== formattedRatio) {
        kdValue.textContent = formattedRatio;
        animateValue(kdValue);
    }
}

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch (data.type) {
        case 'showUI':
            container.classList.add('show');
            break;
            
        case 'hideUI':
            container.classList.remove('show');
            break;

        case 'update':
            if (data.values) {
                updateValues(data.values);
            }
            break;
    }
});
