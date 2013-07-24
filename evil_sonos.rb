#! /usr/bin/ruby

require 'sonos'

$system = Sonos::System.new
$previous = {}
$current = {}
$target = {}

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
  #when "party" , "party on" , "all speakers"
    #system.party_mode
  #when "party off" , "all speakers"
    #system.party_over  
  when "set"
  	print "What volume level? "
	$system.speakers[zone_id.to_i].volume = gets.chomp	
  when "add"
  	$system.speakers[zone_id.to_i].add_to_queue("x-sonos-spotify:spotify:track:4DCCMtWcfWWlGg4EIK79Md?sid=12&amp;flags=0")
  else
  	puts "Invalid command.  Please try another one"
  end
end

def convert_timestamp_to_seconds(timestamp)
	ary = timestamp.split(":")
	val = ary[0].to_i * 3600 + ary[1].to_i * 60 + ary[2].to_i
end

while true do
  $system.speakers.each do |zone|
	  $current[zone.name] = zone.now_playing[:current_position] unless zone.now_playing.nil?
  end
  $previous.each do |k,v|
	  unless $current[k].nil?
	  	prev = convert_timestamp_to_seconds($previous[k])
	  	curr = convert_timestamp_to_seconds($current[k])
	  	$target[k] = v if (prev < curr)
	    #$target[k] = v if $previous[k].to_i < $current[k].to_i
	  end
  end
  puts $previous, $current,$target
  $previous = $current.dup
  $current = {}
  sleep 1
end
