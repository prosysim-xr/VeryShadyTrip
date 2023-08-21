Shader "Unlit/SimpleRGBBlend"{//This is probably unity's shader lab boiler plate
    Properties{//Input Data
        _Color ("Color", Color) = (1,1,1,1)
        _Value ("Value", Float) = 1.0
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
                float2 uv : TEXCOORD0;//Setting Data stream UV map
                float3 normals : Normal;//Setting Data stream to narmal Vector data
                //float3 someValue : TEXCOORD2;//Setting Data stream to narmal Vector data
            };

            //Interpolators, Vertices Input, Vertex to fragment
            struct v2f{
                float4 vertex : SV_POSITION;//clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
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

                //o.normal = v.normals;//passed normal from mesh vertices to v2f  struct (to be interpolated in something)
                
                //o.normal = UnityObjectToWorldNormal(v.normals)
                //o.normal = mul(v.normals, (float3x3)unity_WorldToObject); 
                o.normal = mul((float3x3)unity_ObjectToWorld, v.normals); 
                o.normal = mul((float3x3)UNITY_MATRIX_M, v.normals); //All these are equivalent.( Model Matrix)
                o.uv = v.uv;
                return o;
            }
            //Interpolators goes into fragment shader
            fixed4 frag (v2f i) : SV_Target{//SV_Target is semantics (and boiler plate needs to be there)

                _Color = float4(i.normal, 1);
                //_Color = float4(-i.normal.x,-i.normal.y,-i.normal.z, 1); //normals flipped

                //swizling
                //_Color = _Color.xxxx; //grey scale

                _Color = float4(i.uv.yx,0, 1);

                return _Color;
            }

            
            ENDCG
        }
    }
}
