Shader "Learn Unity Shader/Learn Blink"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _MaskTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 m = tex2D (_MaskTex, IN.uv_MaskTex);
            o.Albedo = c.rgb;
            o.Emission = c.rgb * m.g;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
