Shader "Learn Unity Shader/Learn Blink"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _BlinkSpeed ("Blink Speed", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _MaskTex;
        sampler2D _RampTex;
        float _BlinkSpeed;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskTex;
            float2 uv_RampTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 m = tex2D (_MaskTex, IN.uv_MaskTex);
            float4 Ramp = tex2D (_RampTex, float2 (_Time.y * _BlinkSpeed, 0.5));

            o.Albedo = c.rgb;
            o.Emission = c.rgb * m.g * Ramp.r;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
