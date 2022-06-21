Shader "Learn Unity Shader/Learn Cubemap Reflection"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Cube ("Cubemap", Cube) = "" {}
        _Reflection ("Reflection", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based lambert lighting model, and enable shadows on all light types
        #pragma surface surf Lambert noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;
        samplerCUBE _Cube;
        float _Reflection;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 re = texCUBE (_Cube, WorldReflectionVector(IN, o.Normal));

            o.Albedo = c.rgb;
            o.Emission = re.rgb * _Reflection;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
