require 'byebug'
p "top"

MODULES = ["ruby", "javascript", "react", "sql", "rails"]
SUBSECTIONS = ["projects", "homeworks", "readings"]

def filter_project_directories(mod)
    projects = Dir.entries("#{mod}/homeworks")
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
    curr_project_files = Dir.entries("#{mod}/homeworks/#{project}")
    idx = curr_project_files.index("README.md")
        if idx
            # if there is a readme
            file_name = "#{mod}/homeworks/#{project}/#{curr_project_files[idx]}"
            write_to_file(file_name, project, mod)
            # snippets += File.read(filename).scan(/]: \.\.?\/[\.\w\/ ?=#-]+/) 
            
        end
end

def write_to_file(file_name, project, mod)
    text = File.read(file_name)

    snippets = text.scan(/(^\[(.|-)+\]\:\s(?!http).*)/)
                        # (^\[(.|-)+\]\:\s(?!http).*)
    snippets += text.scan(/(\[(\w|\s)+\]\((\w|\.|\/|\-)+\))/)
    snippets.flatten!
debugger
p text
    snippets.each do |snip|

        no_proj_string = "https://github.com/appacademy/curriculum/blob/master/#{mod}/"
        # ^^ for non project related items like skeletons etc.

        proj_string = "https://github.com/appacademy/curriculum/blob/master/#{mod}/homeworks/#{project}/"
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
            proj_string = "https://github.com/appacademy/curriculum/blob/master/#{mod}/homeworks/"
        end
#    need to figure how to know if end of page or inline
        no_proj_arr = ["read", "demo", "proj"]
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
        end_idx = snip.index("]")
        lett_idx = end_idx

        if lett_idx == nil
            return "x", "x"
            # error handling
        end

        while lett_idx < snip.length
            break if letters.include?(snip[lett_idx])
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









# def trial
#     file_names = ['foo.txt', 'bar.txt']

#     file_names.each do |file_name|
#     text = File.read(file_name)
#     snippets = File.read("ruby/projects/#{project}/#{file_name}").scan(/]: \.\.?\/[\.\w\/ ?=#-]+/)
#     snippets.each do |snip|
#         # find the end of the ./ in each snip
#         lett_idx
#         letters = ("a".."z")
#         snip.chars.each.with_index do |lett, i|
#             if letters.include(lett)
#                 p snip
#                 lett_idx = i
#                 break
#             end
#         end
#         # new string = "]: appacademy/curriculum/blob/master/ruby/#{snip[lett_idx..-1]}"
#         # ^^ for non project related items like skeletons etc.

#         # new string = "]: appacademy/curriculum/blob/master/ruby/projects/#{project_name}/#{snip[lett_idx..-1]}"
#         # ^^ for project specific items
#     end

#     new_contents = text.gsub(/]: \.\.?\/[\.\w\/ ?=#-]+/, "replacement string")

#     # write changes to the file, use:
#     File.open(file_name, "w") {|file| file.puts new_contents }
#     end
# end









# do |f1|  
#   while line = /]: \.\.?\/[\.\w\/ ?=#-]+/
#     puts line  
#   end  
# end  
  
# # Create a new file and write to it  
# File.open('1.rb', 'w') do |f2|  
#   # use "\n" for two lines of text  
#   f2.puts "Created by Satish\nThank God!"  
# end  