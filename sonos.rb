#! /usr/bin/ruby

require 'sonos'

$system = Sonos::System.new

def zone_menu
  i=1
  $system.topology.each do |zone| 
    puts i.to_s + ". " + zone.name
    i+=1
  end
  puts "type exit to end the program"
end

def select_zone
  print "Select the Zone to change: "
  zone_id = gets.chomp
  if zone_id == "exit"
    exit
  else
    return zone_id = zone_id.to_i - 1
  end
end

def execute_command(command, zone_id)
  case command
  when "play"
    $system.speakers[zone_id.to_i].play
  when "pause"
    $system.speakers[zone_id.to_i].pause
  when "next", "skip"
    $system.speakers[zone_id.to_i].next
  when "previous", "last"
    $system.speakers[zone_id.to_i].previous
  when "playing"
	$system.speakers[zone_id.to_i].now_playing
  when "up"
    $system.speakers[zone_id.to_i].volume += 10	
  when "down"
    $system.speakers[zone_id.to_i].volume -= 10	
  when "set"
  	print "What volume level? "
	$system.speakers[zone_id.to_i].volume = gets.chomp	
  when "add"
  	$system.speakers[zone_id.to_i].add_to_queue("x-sonos-spotify:spotify:track:4DCCMtWcfWWlGg4EIK79Md?sid=12&amp;flags=0")
  else
  	puts "Invalid command.  Please try another one"
  end
end

while true do
  zone_menu
  zone_id = select_zone
  print "What do you want to do? "
  execute_command(gets.chomp, zone_id)
end