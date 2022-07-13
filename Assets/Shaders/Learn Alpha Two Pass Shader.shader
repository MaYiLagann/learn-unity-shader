Shader "Learn Unity Shader/Learn Alpha Two Pass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Alpha ("Alpha", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        // 1st pass, zwrite on and rendering off
        zwrite on
        ColorMask 0

        CGPROGRAM
        #pragma surface surf Nolight noambient noforwardadd nolightmap novertexlights noshadow

        float _Alpha;

        struct Input
        {
            float4 color:Color;
        };

        void surf (Input IN, inout SurfaceOutput o) { }
        float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, _Alpha);
        }
        ENDCG

        // 2nd pass, zwrite off and rendering on

        zwrite off

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade keepalpha

        sampler2D _MainTex;
        float _Alpha;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = _Alpha;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}
