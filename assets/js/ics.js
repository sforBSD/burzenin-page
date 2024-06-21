  document.querySelectorAll('.download-ics').forEach(link => {
      link.addEventListener('click', function (event) {
          event.preventDefault();

          // Get event details from data attributes
          const eventDetails = {
              start: this.getAttribute('data-start'),
              end: this.getAttribute('data-end'),
              title: this.getAttribute('data-title'),
              description: this.getAttribute('data-description'),
              location: this.getAttribute('data-location'),
              url: this.getAttribute('data-url')
          };

          // Create iCal string
          const icalString = `
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Sample Corp//NONSGML Event//EN
BEGIN:VEVENT
UID:${new Date().toISOString()}@sample.com
DTSTAMP:${new Date().toISOString().replace(/[-:]/g, '').split('.')[0]}Z
DTSTART:${eventDetails.start}
DTEND:${eventDetails.end}
SUMMARY:${eventDetails.title}
DESCRIPTION:${eventDetails.description}
LOCATION:${eventDetails.location}
URL:${eventDetails.url}
END:VEVENT
END:VCALENDAR
          `.trim();

          // Encode iCal string in Base64
          const base64String = btoa(icalString);

          // Create a download link
          const downloadLink = document.createElement('a');
          downloadLink.href = 'data:text/calendar;base64,' + base64String;
          downloadLink.download = `${eventDetails.title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}.ics`;
          downloadLink.style.display = 'none';

          // Append the link to the body
          document.body.appendChild(downloadLink);

          // Programmatically click the download link
          downloadLink.click();

          // Remove the link from the document
          document.body.removeChild(downloadLink);
      });
  });