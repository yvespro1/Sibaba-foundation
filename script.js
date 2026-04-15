async function applyImageConfig() {
  try {
    const response = await fetch('site-config.json');
    if (!response.ok) return;
    const config = await response.json();
    const images = (config && config.images) ? config.images : {};

    document.querySelectorAll('[data-img-key]').forEach((el) => {
      const key = el.getAttribute('data-img-key');
      const src = images[key];
      if (!src) return;

      if (el.tagName === 'IMG') {
        el.src = src;
      } else {
        el.style.backgroundImage = `url("${src}")`;
      }
    });
  } catch (err) {
    // silent fallback to existing HTML src values
  }
}

applyImageConfig();

// ===== DOM Elements =====
const body = document.body;
const nav = document.getElementById('nav');
const hamburger = document.getElementById('hamburger');
const searchToggle = document.getElementById('searchToggle');
const searchBar = document.getElementById('searchBar');
const darkModeToggle = document.getElementById('darkModeToggle');
const backToTop = document.getElementById('backToTop');
const closeAnnouncement = document.querySelector('.close-announcement');
const header = document.getElementById('header');

// ===== Mobile Nav Toggle =====
if (hamburger) {
  hamburger.addEventListener('click', () => {
    nav.classList.toggle('open');
  });
}

// ===== Search Bar Toggle =====
if (searchToggle) {
  searchToggle.addEventListener('click', () => {
    searchBar.classList.toggle('active');
    if (searchBar.classList.contains('active')) {
      searchBar.querySelector('input').focus();
    }
  });
}

// ===== Dark Mode Toggle =====
if (darkModeToggle) {
  // Restore saved preference
  if (localStorage.getItem('darkMode') === 'true') {
    body.classList.add('dark-mode');
  }
  darkModeToggle.addEventListener('click', () => {
    body.classList.toggle('dark-mode');
    localStorage.setItem('darkMode', body.classList.contains('dark-mode'));
  });
}

// ===== Close Announcement Bar =====
if (closeAnnouncement) {
  closeAnnouncement.addEventListener('click', () => {
    closeAnnouncement.closest('.announcement-bar').style.display = 'none';
  });
}

// ===== Scroll: Back to Top + Header Shadow =====
window.addEventListener('scroll', () => {
  // Back to top button
  if (backToTop) {
    if (window.scrollY > 350) {
      backToTop.classList.add('show');
    } else {
      backToTop.classList.remove('show');
    }
  }
  // Header shadow on scroll
  if (header) {
    if (window.scrollY > 10) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  }
});

if (backToTop) {
  backToTop.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
}

// ===== FAQ Accordion =====
document.querySelectorAll('.faq-question').forEach((btn) => {
  btn.addEventListener('click', () => {
    const item = btn.closest('.faq-item');
    // Close other open items
    document.querySelectorAll('.faq-item.active').forEach((openItem) => {
      if (openItem !== item) openItem.classList.remove('active');
    });
    item.classList.toggle('active');
  });
});


// ===== Contact Form =====
const contactForm = document.getElementById('contactForm');
const formSuccess = document.getElementById('formSuccess');

if (contactForm) {
  contactForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const submitBtn = contactForm.querySelector('button[type="submit"]');
    const originalText = submitBtn.textContent;
    submitBtn.textContent = 'Sending...';
    submitBtn.disabled = true;

    try {
      const name = document.getElementById('name').value;
      const email = document.getElementById('email').value;
      const message = document.getElementById('message').value;

      await fetch("https://formsubmit.co/ajax/sibabadentalclinic@gmail.com", {
        method: "POST",
        headers: { 
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify({
            name: name,
            email: email,
            message: message
        })
      });

      if (formSuccess) formSuccess.classList.add('show');
      contactForm.reset();
      setTimeout(() => {
        if (formSuccess) formSuccess.classList.remove('show');
      }, 5000);
    } catch (error) {
      alert("There was an issue sending your message. Please verify your connection and try again.");
    } finally {
      submitBtn.textContent = originalText;
      submitBtn.disabled = false;
    }
  });
}

// ===== Search Functionality =====
const searchBtn = document.getElementById('searchBtn');
if (searchBtn) {
  searchBtn.addEventListener('click', () => {
    const val = document.getElementById('searchInput').value.trim();
    if (!val) return;
    const key = val.toLowerCase();

    // Page-level search mapping
    const pageMap = {
      'education': 'education-services.html',
      'services': 'education-services.html',
      'programs': 'education-services.html',
      'problem': 'education-services.html#problem',
      'methodology': 'education-services.html#solution',
      'impact': 'education-services.html#impact',
      'about': 'about.html',
      'faq': 'about.html#faq',
      'history': 'about.html',
      'contact': 'index.html#contact',
      'tools': 'index.html#tools',
      'dentures': 'index.html#education',
      'plastic teeth': 'index.html#education',
      'doctors': 'index.html#doctors',
    };

    // Find best match
    let target = null;
    for (const [keyword, url] of Object.entries(pageMap)) {
      if (key.includes(keyword)) {
        target = url;
        break;
      }
    }

    if (target) {
      window.location.href = target;
    } else {
      // Default: try to find section on current page
      const section = document.getElementById(key);
      if (section) {
        section.scrollIntoView({ behavior: 'smooth' });
      } else {
        alert('No results found for "' + val + '". Try searching for: education, services, about, tools, or doctors.');
      }
    }
  });

  // Allow Enter key in search
  const searchInput = document.getElementById('searchInput');
  if (searchInput) {
    searchInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        searchBtn.click();
      }
    });
  }
}

// ===== Scroll Animations (Intersection Observer) =====
const fadeElements = document.querySelectorAll('.fade-in');

if (fadeElements.length > 0 && 'IntersectionObserver' in window) {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.1, rootMargin: '0px 0px -40px 0px' }
  );

  fadeElements.forEach((el) => observer.observe(el));
}

// ===== Close mobile nav on link click =====
document.querySelectorAll('.nav-link').forEach((link) => {
  link.addEventListener('click', () => {
    if (nav && nav.classList.contains('open')) {
      nav.classList.remove('open');
    }
  });
});

// ===== Custom Video Player =====
const videoOverlay = document.getElementById('videoOverlay');
const promoVideo = document.getElementById('promoVideo');

if (videoOverlay && promoVideo) {
  videoOverlay.addEventListener('click', () => {
    videoOverlay.style.display = 'none';
    promoVideo.setAttribute('controls', 'true');
    promoVideo.play();
  });
}

