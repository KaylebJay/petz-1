local modpath, S = ...

--
--Particle Effects
--

petz.do_particles_effect = function(obj, pos, particle_type)
    local minpos
    minpos = {
        x = pos.x,
        y = pos.y,
        z = pos.z
    }        
    local maxpos
    maxpos = {
        x = minpos.x+0.4,
        y = minpos.y-0.5,
        z = minpos.z+0.4
    }    
    local texture_name
    local particles_amount
    local min_size
    local max_size
    if particle_type == "star" then
        texture_name = "petz_star_particle.png"
        particles_amount = 20
		min_size = 1.0
		max_size = 1.5
    elseif particle_type == "heart" then
        texture_name = "petz_affinity_heart.png"
        particles_amount = 10
 		min_size = 1.0
		max_size = 1.5
    elseif particle_type == "pregnant_pony" then
        texture_name = "petz_pony_pregnant_icon.png"
        particles_amount = 10
        min_size = 5.0
		max_size = 6.0 
	elseif particle_type == "pregnant_lamb" then
        texture_name = "petz_lamb_pregnant_icon.png"
        particles_amount = 10
        min_size = 5.0
		max_size = 6.0 
	elseif particle_type == "pregnant_camel" then
        texture_name = "petz_camel_pregnant_icon.png"
        particles_amount = 10
        min_size = 5.0
		max_size = 6.0 
	elseif particle_type == "dreamcatcher" then
        texture_name = "petz_dreamcatcher_particle.png"
        particles_amount = 15
        min_size = 1.0
		max_size = 2.0 
    end
    minetest.add_particlespawner({
        --attached = obj,
        amount = particles_amount,
        time = 1.5,
        minpos = minpos,
        maxpos = maxpos,
        --minvel = {x=1, y=0, z=1},
        --maxvel = {x=1, y=0, z=1},
        --minacc = {x=1, y=0, z=1},
        --maxacc = {x=1, y=0, z=1},
        minexptime = 1,
        maxexptime = 1,
        minsize = min_size,
        maxsize =max_size,
        collisiondetection = false,
        vertical = false,
        texture = texture_name,        
        glow = 14
    })
end
