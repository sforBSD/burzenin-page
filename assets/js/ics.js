function downloadICS(event, start, end, title, description, location, url) {
    // Prevent default action
    event.preventDefault();

    // Create iCal string
    const icalString = `
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Sample Corp//NONSGML Event//EN
BEGIN:VEVENT
UID:${new Date().toISOString()}@sample.com
DTSTAMP:${new Date().toISOString().replace(/[-:]/g, '').split('.')[0]}Z
DTSTART:${start}
DTEND:${end}
SUMMARY:${title}
DESCRIPTION:${description}
LOCATION:${location}
URL:${url}
END:VEVENT
END:VCALENDAR
    `.trim();

    // Encode iCal string in Base64
    const base64String = btoa(icalString);

    // Create a download link
    const downloadLink = document.createElement('a');
    downloadLink.href = 'data:text/calendar;base64,' + base64String;
    downloadLink.download = `${title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}.ics`;
    downloadLink.style.display = 'none';

    // Append the link to the body
    document.body.appendChild(downloadLink);

    // Programmatically click the download link
    downloadLink.click();

    // Remove the link from the document
    document.body.removeChild(downloadLink);
}