Shader "Learn Unity Shader/Learn Outline Fresnel"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _OutlineColor ("Outline Color", Color) = (1,1,1,1)
        _OutlineWidth ("Outline Width", Range(0,1)) = 0.3
        _ToonLevel ("Toon Level", Range(1,10)) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Toon noambient noshadow

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _OutlineColor;
        float _OutlineWidth;
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

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float ndot1 = dot(s.Normal, lightDir) * 0.5 + 0.5;
            ndot1 = ndot1 * _ToonLevel;
            ndot1 = ceil(ndot1) / _ToonLevel;

            float rim = abs(dot(s.Normal, viewDir));
            rim = rim > _OutlineWidth ? 1 : -1;

            float4 final;
            final.rgb = rim == 1 ? s.Albedo * ndot1 * _LightColor0.rgb : _OutlineColor;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
