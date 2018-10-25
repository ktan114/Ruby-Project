class Html

    DEFAULT_BROWSER = 'chromium-browser -new-window  --enable-plugins    --allow-outdated-plugins '

    def run file, args
        if args.empty?
            system "#{DEFAULT_BROWSER} #{file}"
        else
            dispatch_on_parameters file, args
        end
    end

    def dispatch_on_parameters file, args
        cmd = args.shift
        send "do_#{cmd}", file, args
    end

    def do_opera file, args=nil
        system "opera #{file} #{args}"
    end

    def do_konq file, args=nil
        system "konqueror #{file}  #{args}"
    end

    # The code creates a REXML Document object and assigns it to dom.
    # If there are no extra arguments, you get back a basic report
    # Otherwise the code does cursory examination of a particular element
    def do_report file, args=nil
        require 'rexml/document'
        begin
            dom = REXML::Document.new( IO.read( file ) )
            if args.empty?
                puts basic_xhtml_report( dom )
            else
                puts report_on( dom, args.first )
            end
        rescue Exception
            warn "There was a problem reading '#{file}': \n#{$!}"
        end
    end

    # The report_on method takes a document argument and an element name, and
    # uses REXML's XPath features to find out how often the element is used.
    def report_on dom, element
        els = dom.root.elements.to_a "//#{element}"
        "The document has #{els.size} '#{element}' elements"
    end

    # The basic_xhtml_report method focuses on a particular set of elements. It uses
    # REXML to find all the CSS and JS references and use the File class
    # to check that the referenced files exist
    def basic_xhtml_report dom
        report = []
        css = dom.root.elements.to_a '//link[@rel="stylesheet"]'
        unless css.empty?
            report << "The file reference #{css.size} stylesheets"
            css.each do |el|
                file_name = el.attributes['href']
                file_name.gsub! /^\//, ''
                unless File.exist? file_name
                    report <<"*** Cannot find stylesheet file '#{file_name}'"
                end
            end
        end

        js = dom.root.elements.to_a '//script'
        unless js.empty?
            report << "The file references #{js.size} JavaScript files"
            js.each do |el|
                file_name = el.attributes['src']
                file_name.gsub! /^//, ''
                unless File.exist? file_name
                    report << "*** Cannot find JavaScript file '#{file_name}'"
                end
            end
        end

    report.join "\n"
end
    