
#The modified version uses Tk to display for better UI
#use some modules
use Tk;
use Term::ReadKey;
require Term::Screen::Uni;
use threads;


our @pixel_frames;
		
our $mw = new MainWindow;
our $no_pixels = 20;	
our $cell_width = 20;
our $frm_1 = $mw -> Frame(-width =>300, -height => 300, -background => "black");
# Intializing the frame
for my $i(0..$no_pixels-1){
	for my $j(0..$no_pixels-1){
		if($i>$j){
			$pixel_frames[$i][$j] = $frm_1 -> Frame(-width =>$cell_width, -height => $cell_width, -background => "red")->pack();
		}else{
			$pixel_frames[$i][$j] = $frm_1 -> Frame(-width =>$cell_width, -height => $cell_width, -background => "blue")->pack();
		}
		$pixel_frames[$i][$j]-> grid(-row=>$i,-column=>$j);
	}
}
$frm_1->pack();
	


#Here is the game array 2d


for $i (0..$no_pixels-1){
	for $j (0..$no_pixels-1){
		$pixel[$i][$j] = 0;
	}
}

#snake_description is n*2
our @snake_description; 

#snake_direction is n sized array. 

our @snake_direction;
our @movements;
our $random_index_x;
our $random_index_y;

our $size;

sub reset{
	$size = 2; #This is the size of the snake

	#Generate random first position of snake and mouse
	$random_index_x = int(rand($no_pixels));
	$random_index_y = int(rand($no_pixels));

	$snake_description[0][0] = $random_index_x;
	$snake_description[0][1] = $random_index_y;
	@movements = ("up","down","left","right");

	#Generate random snake movement.
	$random_direction = int(rand(4));
	$snake_movement = $movements[$random_direction];


	$snake_direction[0] = $snake_movement;
	$snake_direction[1] = $snake_movement;
	if($snake_movement eq "up"){
		$snake_description[1][1] = $snake_description[0][1];
		$snake_description[1][0] = ($snake_description[0][0] + 1)%$no_pixels;
	} elsif ($snake_movement eq "down"){
		$snake_description[1][1] = $snake_description[0][1];
		$snake_description[1][0] = ($snake_description[0][0] - 1)%$no_pixels;
	}elsif($snake_movement eq "left"){
		$snake_description[1][0] = $snake_description[0][0];
		$snake_description[1][1] = ($snake_description[0][1] + 1)%$no_pixels;
	}elsif($snake_movement eq "right"){
		$snake_description[1][0] = $snake_description[0][0];
		$snake_description[1][1] = ($snake_description[0][1] - 1)%$no_pixels;
	}

	$pixel[$snake_description[0][0]][$snake_description[0][1]] = 1;
	$pixel[$snake_description[1][0]][$snake_description[1][1]] = 1;
	
	update_mouse_position();
	update_display();	
}



sub update_mouse_position{
	$random_mouse_x = int(rand($no_pixels));
	$random_mouse_y = int(rand($no_pixels));
	if($pixel[$random_mouse_x][$random_mouse_y]==1){
		update_mouse_position();
	}		
}

sub takeinput{
	ReadMode('cbreak');
	$change = ReadKey(0);
	ReadMode('normal');	
		
	#print "In take input: $change\n";
	if(index("w",$change)!=-1){
		if($snake_direction[0] eq "down"){
		}else{
			#print "Changing to Up\n";
			$snake_direction[0] = "up";
		}	
	}elsif($change eq "a"){
		if($snake_direction[0] eq "right"){
		}else{
			$snake_direction[0] = "left";
		}	
	}elsif($change eq "s"){
		if($snake_direction[0] eq "up"){
		}else{
			$snake_direction[0] = "down";
		}	
	}elsif($change eq "d"){
		if($snake_direction[0] eq "left"){
		}else{
			$snake_direction[0] = "right";
		}	
	}
}

sub dead{
	print "You are dead\nFinal Score: $size\n";
}

sub update_gui{
	while(1==1){
		
		update_display();
		$last_coordinate_x = $snake_description[$size-1][0];
		$last_coordinate_y = $snake_description[$size-1][1];
		$inc = 0;
		$pixel[$last_coordinate_x][$last_coordinate_y] = 0;
		
		takeinput();
		
		$i=0;
		while ($i<=$size-1){
			if($snake_direction[$i] eq "left"){
				if($i==0){
					 if($pixel[$snake_description[$i][0]][($snake_description[$i][1] - 1) %$no_pixels]==1){
						dead();
						return;
						break;
					}elsif($snake_description[$i][0]==$random_mouse_x && ($snake_description[$i][1] - 1) %$no_pixels==$random_mouse_y){
						$inc = 1;
						update_mouse_position();
					}
				}
				$snake_description[$i][1] = ($snake_description[$i][1] - 1) %$no_pixels;	
				
			}elsif($snake_direction[$i] eq "right"){
				if($i==0){
					 if($pixel[$snake_description[$i][0]][($snake_description[$i][1] + 1) %$no_pixels]==1){
						dead();
						return;
						break;
					}elsif($snake_description[$i][0]==$random_mouse_x && ($snake_description[$i][1] + 1) %$no_pixels==$random_mouse_y){
						$inc = 1;
						update_mouse_position();
					}
				}
				$snake_description[$i][1] = ($snake_description[$i][1] + 1) %$no_pixels;	
				
	
			}elsif($snake_direction[$i] eq "down"){
				if($i==0){
					 if($pixel[($snake_description[$i][0] + 1) %$no_pixels][$snake_description[$i][1]]==1){
						dead();
						return;
						break;
					}elsif(($snake_description[$i][0] + 1) %$no_pixels==$random_mouse_x && $snake_description[$i][1]==$random_mouse_y){
						$inc = 1;
						update_mouse_position();
					}
				}
				$snake_description[$i][0] = ($snake_description[$i][0] + 1) %$no_pixels;	
				

			}elsif($snake_direction[$i] eq "up"){
				if($i==0){
					 if($pixel[($snake_description[$i][0] - 1) %$no_pixels][$snake_description[$i][1]]==1){
						dead();
						return;
						break;
					}elsif(($snake_description[$i][0] - 1) %$no_pixels==$random_mouse_x && $snake_description[$i][1]==$random_mouse_y){
						$inc = 1;
						update_mouse_position();
					}
				}
				$snake_description[$i][0] = ($snake_description[$i][0] - 1) %$no_pixels;	
			}
			$i = $i+1;
		}
		
		if($inc == 1){
			$size = $size + 1;
			$factor = int(rand(2000))/1000;
			$snake_description[$size-1][0] = $last_coordinate_x;
			$snake_description[$size-1][1] = $last_coordinate_y;
			$snake_direction[$size-1] = $snake_direction[$size-2]; 
			$pixel[$last_coordinate_x][$last_coordinate_y]=1;
		}
		for $j(1..$size-1){
				$snake_direction[$size-$j] = $snake_direction[$size-$j-1];
		}
		$pixel[$snake_description[0][0]][$snake_description[0][1]] = 1; 	
	}	
}
reset();
$gui_thread = threads->create(\&update_gui);
MainLoop();
$gui_thread->join;
