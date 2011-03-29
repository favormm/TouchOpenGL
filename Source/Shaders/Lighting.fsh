#ifdef GL_ES
precision lowp float;
#endif

varying vec4 v_color;

void main()
    {
    
// Emulates glAlphaFunc - not needed?
//    if (v_color.a == 0.0)
//        {
//        discard;
//        }


	gl_FragColor = v_color;
    }
