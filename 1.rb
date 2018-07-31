require 'byebug'
p "top"

MODULES = ["ruby", "javascript", "react", "sql", "rails"]
SUBSECTIONS = ["projects", "homeworks", "readings"]

def filter_project_directories(mod)
    projects = Dir.entries("#{mod}/projects")
    filtered_projects = projects.select do |project|
                            project unless project.include?(".")
                            #  might need to ignore _deprecated as well
                            end
            # misses projects like "git-workflow-exercises.md"
    return filtered_projects
end

def find_projects(projects, mod)
    projects.each do |project|
            find_readme(project, mod)
        end
end

def find_readme(project, mod)
    curr_project_files = Dir.entries("#{mod}/projects/#{project}")
    idx = curr_project_files.index("README.md")
        if idx
            # if there is a readme
            file_name = "#{mod}/projects/#{project}/#{curr_project_files[idx]}"
            write_to_file(file_name, project, mod)
            # snippets += File.read(filename).scan(/]: \.\.?\/[\.\w\/ ?=#-]+/) 
            
        end
end

def write_to_file(file_name, project, mod)
    text = File.read(file_name)

    snippets = text.scan(/(^\[(.|-)+\]\:\s*(?!http).*)/)
                        # (^\[(.|-)+\]\:\s(?!http).*)
    snippets += text.scan(/(\[(\w|\s)+\]\((\w|\.|\/|\-)+\))/)
    snippets.flatten!
debugger
    snippets.each do |snip|
    # if project == "css-friends"
    #     debugger
    # end
        no_proj_string = "https://github.com/appacademy/curriculum/blob/master/#{mod}/"
        # ^^ for non project related items like skeletons etc.

        proj_string = "https://github.com/appacademy/curriculum/blob/master/#{mod}/projects/#{project}/"
        # ^^ for project specific items


        next if snip.length < 2
        # ignores one character false positives

        prefix, new_snip, flag = trim_snip(snip)

        if prefix == new_snip && prefix == "x" 
            p "--------------------------------"
            p "error in this file:"
            p file_name
            p "project"
            p project
            p "module"
            p mod
            p "--------------------------------"
            next
        end

        if flag
            proj_string = "https://github.com/appacademy/curriculum/blob/master/#{mod}/projects/"
        end
        # if project == "css-friends"
        #     no_proj_string += "css-friends/"
        # end
#    need to figure how to know if end of page or inline
        no_proj_arr = ["read", "demo", "proj", "docs"]
        if no_proj_arr.include?(new_snip[0..3])
            new_link = prefix + no_proj_string + new_snip
        else
            new_link = prefix + proj_string + new_snip
        end
       debugger if new_link == nil

        a = text.gsub(snip, new_link)
        p a
    end
    # File.open(file_name, "w") {|file| file.puts text }
    # this should do the actual overwriting to the file
end


def trim_snip(snip)

        letters = ("a".."z") 
        cap_letters = ("A".."Z")
        end_idx = snip.index("]")
        lett_idx = end_idx

        if lett_idx == nil
            return "x", "x"
            # error handling
        end

        while lett_idx < snip.length
            break if letters.include?(snip[lett_idx])
            break if cap_letters.include?(snip[lett_idx])
            lett_idx += 1
        end

        prefix = snip[0..end_idx]
        prefix += snip.include?(":") ? ": " : "("
        flag = false
        if snip[(lett_idx - 4)..(lett_idx-1)] == " ../"
            flag = true
        end
        return prefix, snip[lett_idx..-1], flag
end

def relative_link_scrub
    MODULES.each.with_index do |mod, i|
    # mod = "html-css"
        find_projects(filter_project_directories(mod), mod)
        p "------------------------------------"
        p "------------------------------------"
        p "------------------------------------"
        p "------------------------------------"
        p "mod"
        p mod
        p "mod"
        p "------------------------------------"
        p "------------------------------------"
        p "------------------------------------"
        p "------------------------------------"
        p "------------------------------------"
        # break if i > 2
    end
end

relative_link_scrub
