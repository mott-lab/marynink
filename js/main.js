/* Mary Nink — site script: mobile nav, footer year, contact form. */
(function () {
  'use strict';

  /* Mobile navigation toggle ------------------------------------------- */
  var toggle = document.querySelector('.nav-toggle');
  var nav = document.getElementById('site-nav');
  if (toggle && nav) {
    toggle.addEventListener('click', function () {
      var open = nav.classList.toggle('is-open');
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && nav.classList.contains('is-open')) {
        nav.classList.remove('is-open');
        toggle.setAttribute('aria-expanded', 'false');
        toggle.focus();
      }
    });
  }

  /* Footer year ---------------------------------------------------------- */
  var year = document.getElementById('year');
  if (year) year.textContent = String(new Date().getFullYear());

  /* Contact form ----------------------------------------------------------
     Two modes, chosen by the form's data-endpoint attribute:
       - empty  → opens the visitor's mail app with the message pre-filled
       - a URL  → POSTs JSON to that URL (Formspree, Netlify Forms, etc.)
     See README.md for wiring up Formspree. */
  var form = document.getElementById('contact-form');
  if (!form) return;

  var status = form.querySelector('.form__status');
  var endpoint = (form.getAttribute('data-endpoint') || '').trim();
  var mailto = form.getAttribute('data-mailto') || '';

  // contact.html?topic=lessons preselects the lessons option (used by the Teaching page)
  var topicSelect = form.querySelector('select[name="topic"]');
  if (topicSelect && /[?&]topic=lessons\b/.test(window.location.search)) {
    topicSelect.value = 'Voice or acting lessons';
  }

  function setStatus(text, state) {
    if (!status) return;
    status.textContent = text;
    status.setAttribute('data-state', state || '');
  }

  form.addEventListener('submit', function (e) {
    e.preventDefault();

    var honey = form.querySelector('input[name="website"]');
    if (honey && honey.value) return; // bot filled the hidden field

    var data = new FormData(form);
    var name = (data.get('name') || '').toString().trim();
    var email = (data.get('email') || '').toString().trim();
    var topic = (data.get('topic') || '').toString();
    var message = (data.get('message') || '').toString().trim();

    if (!name || !email || !message) {
      setStatus('Please fill in your name, email, and a message.', 'error');
      return;
    }

    if (!endpoint) {
      var subject = encodeURIComponent('[marynink.com] ' + topic + ' — ' + name);
      var body = encodeURIComponent(message + '\n\n— ' + name + ' (' + email + ')');
      window.location.href = 'mailto:' + mailto + '?subject=' + subject + '&body=' + body;
      setStatus('Opening your mail app…', 'sent');
      return;
    }

    var button = form.querySelector('button[type="submit"]');
    if (button) button.disabled = true;
    setStatus('Sending…', '');

    fetch(endpoint, {
      method: 'POST',
      headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: name, email: email, topic: topic, message: message, _subject: topic + ' — ' + name })
    }).then(function (res) {
      if (!res.ok) throw new Error('Request failed');
      form.reset();
      setStatus('Sent. Thank you — expect a reply within a couple of days.', 'sent');
    }).catch(function () {
      setStatus('Something went wrong. Email ' + mailto + ' directly instead.', 'error');
    }).finally(function () {
      if (button) button.disabled = false;
    });
  });
})();
