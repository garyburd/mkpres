(() => {
    const sections = Array.from(document.querySelectorAll('body > section'));
    const upButton = document.getElementById('upButton');
    const downButton = document.getElementById('downButton');

    if (!upButton || !downButton || sections.length === 0) {
      console.warn('Navigation: Required elements not found');
      return;
    }

    let currentSection = 0;

    const observer = new IntersectionObserver((entries) => {
        let maxRatio = 0;
        let mostVisibleEntry = null;
        entries.forEach(entry => {
            if (entry.isIntersecting && entry.intersectionRatio > maxRatio) {
                maxRatio = entry.intersectionRatio;
                mostVisibleEntry = entry;
            }
        });
        if (mostVisibleEntry) {
            const id = mostVisibleEntry.target.id;
            if (id) {
                const currentID = window.location.hash.slice(1); // Remove the '#'
                if (id !== currentID) {
                    history.replaceState(null, null, '#' + id);
                }
            }

            currentSection = sections.indexOf(mostVisibleEntry.target)
            upButton.disabled = currentSection === 0;
            downButton.disabled = currentSection === sections.length - 1;
        }
    }, {
        threshold: [0.5],
    });

    sections.forEach(section => {
        observer.observe(section);
    });

    const scrollToSection = (delta) => {
        const i = Math.min(Math.max(currentSection + delta, 0), sections.length - 1);
        sections[i].scrollIntoView({
            behavior: 'smooth',
        });
    };

    upButton.addEventListener('click', () => {
        scrollToSection(-1);
    });

   downButton.addEventListener('click', () => {
        scrollToSection(1);
    });

})();

