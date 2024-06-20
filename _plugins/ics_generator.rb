# _plugins/ics_generator.rb

require 'icalendar'

module Jekyll
  class ICSGenerator < Generator
    safe true

    def generate(site)
      talks = site.collections['talks'].docs

      talks.each do |talk|
        generate_ics(site, talk)
      end
    end

    def generate_ics(site, talk)
      cal = Icalendar::Calendar.new
      event = Icalendar::Event.new

      event.uid = talk.url
      event.summary = talk.data['title']
      event.dtstart = format_datetime(talk.data['starttime'])
      event.dtend = format_datetime(talk.data['endtime'])
      event.location = talk.data['room']
      event.description = talk.data['description']
      event.url = site.config['url'] + talk.url

      cal.add_event(event)
      cal.publish

      ics_content = cal.to_ical

      # Construct the file path for the .ics file
      ics_filename = "#{talk.data['ics_slug']}.ics"  # Use title for filename, lowercase with underscores
      ics_dir = File.join(site.dest, File.dirname(talk.url))
      ics_path = File.join(ics_dir, ics_filename)

      # Write the .ics content to the file
      FileUtils.mkdir_p(ics_dir)
      File.open(ics_path, 'w') { |file| file.write(ics_content) }
    end

    private

    def format_datetime(datetime_str)
      datetime = DateTime.parse(datetime_str)
      datetime.strftime('%Y%m%dT%H%M%S')
    end
  end
end
