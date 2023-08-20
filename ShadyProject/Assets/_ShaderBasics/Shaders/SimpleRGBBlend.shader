Shader "Unlit/SimpleRGBBlend"{//This is probably unity's shader lab boiler plate
    Properties{
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader    {
        Tags { "RenderType"="Opaque" }
        //LOD 100 //Based on LOD value can change subshader/ pass for better optimization

        Pass{
            CGPROGRAM
            #pragma vertex vert //Pointing vertex shader to vert
            #pragma fragment frag //Pointing fragment shader to frag

            #include "UnityCG.cginc"//For Using library functions
            //Define Structs -->
            //Mesh Data Structure
            struct appdata{
                float4 vertex : POSITION;
                //float2 uv : TEXCOORD0;//Setting Data stream UV map
                float3 normal : Normal;//Setting Data stream to narmal Vector data
                //float3 someValue : TEXCOORD2;//Setting Data stream to narmal Vector data
            };

            //Interpolators, Vertices Input, Vertex to fragment
            struct v2f{
                float4 vertex : SV_POSITION;//clip space position
                float3 normal : TEXCOORD0;
            };


            //Define Variables -->
            float4 _Color; //Can use float, half, fixed based on optimization requirements
            //sampler2D _MainTex;
            //float4 _MainTex_ST;

            //Shader Pipeline (Piping Data) -->
            // Mesh data goes to vertex shader and return Interpolators
            v2f vert (appdata v){
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);//localspace to clipspace
                o.normal = v.normal;//passed normal from mesh vertices to v2f  struct (to be interpolated in something)
                return o;
            }
            //Interpolators goes into fragment shader
            fixed4 frag (v2f i) : SV_Target{//SV_Target is some semantics (internet this)
                _Color = float4(i.normal, 1);
                return _Color;
            }
            ENDCG
        }
    }
}
