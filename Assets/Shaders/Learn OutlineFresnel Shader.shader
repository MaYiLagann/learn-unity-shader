Shader "Learn Unity Shader/Learn Outline Fresnel"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _ToonLevel ("Toon Level", Range(1,10)) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Toon noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _ToonLevel;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndot1 = dot(s.Normal, lightDir) * 0.5 + 0.5;
            ndot1 = ndot1 * _ToonLevel;
            ndot1 = ceil(ndot1) / _ToonLevel;

            float4 final;

            final.rgb = s.Albedo * ndot1 * _LightColor0.rgb;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
