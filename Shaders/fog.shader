shader_type canvas_item;

uniform vec3 clr = vec3(1.0, 1.0, 1.0);
uniform int octaves = 3;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56.0,87.0)) * 1000.0) * 1000.0);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));
	
	vec2 cubicF = f * f * (3.0 - 2.0 * f);
	vec2 linearF = f;
	
	vec2 method = cubicF;
	
	float value = mix(a , b, method.x) + (c - a) * method.y * (1.0 - method.x) + (d - b) * method.x * method.y;
	return value;
}

//fractal brownian motion
float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;
	
	for(int i = 0; i < octaves; i++){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

vec2 rotateVec2(vec2 v, float theta){
	vec2 nv = vec2(v.x * cos(theta) - v.y * sin(theta),
					v.x * sin(theta) + v.y * cos(theta));
	return nv;
}

void fragment(){
	vec2 coord = UV * 10.0;
	vec2 direction = vec2(TIME*0.1, TIME*0.2);
	//float t = floor(TIME);
	direction = rotateVec2(direction, TIME / 1500.0);
	vec2 motion = vec2(fbm(coord + direction));
	float final = fbm((coord + TIME*0.02) + motion * 2.0);
	
	vec4 og = texture(TEXTURE, UV);
	vec4 fclr = vec4(clr, final * 0.1);
	COLOR = fclr;
}



