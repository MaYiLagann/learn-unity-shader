Shader "Learn Unity Shader/Learn Water Reflection"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _MaskMap ("Mask Map", 2D) = "white" {}
        _Cube ("Cubemap", Cube) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based lambert lighting model, and enable shadows on all light types
        #pragma surface surf Lambert noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _MaskMap;
        samplerCUBE _Cube;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_MaskMap;
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 re = texCUBE (_Cube, WorldReflectionVector(IN, o.Normal));
            float m = tex2D (_MaskMap, IN.uv_MaskMap);

            o.Albedo = c.rgb * (1 - m.r);
            o.Emission = re.rgb * m.r;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
