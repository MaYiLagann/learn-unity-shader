Shader "Learn Unity Shader/Learn Refraction"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RefStrength ("Refraction", Range(0.0, 1.0)) = 0.05
        _Color ("Color", Color) = (0.1,0.1,0.1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        zwrite off

        GrabPass {}

        CGPROGRAM
        #pragma surface surf Nolight noambient alpha:fade

        sampler2D _GrabTexture;
        sampler2D _MainTex;
        float _RefStrength;
        float4 _Color;

        struct Input
        {
            float4 color:Color;
            float4 screenPos;
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float4 ref = tex2D (_MainTex, IN.uv_MainTex);

            float3 screenUV = IN.screenPos.rgb;
            if (IN.screenPos.a > 0)
            {
                screenUV /= IN.screenPos.a;
            }

            o.Emission = tex2D (_GrabTexture, screenUV.xy + ref.x * _RefStrength);
        }

        float4 LightingNolight (SurfaceOutput s, float3 lightDir, float atten)
        {
            return _Color;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
