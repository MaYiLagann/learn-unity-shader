Shader "Learn Unity Shader/Learn UV Flow"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FlowSpeedX ("Flow Speed X", float) = 0
        _FlowSpeedY ("Flow Speed Y", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard noambient

        sampler2D _MainTex;
        float _FlowSpeedX;
        float _FlowSpeedY;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, float2(IN.uv_MainTex.x + _Time.y * _FlowSpeedX, IN.uv_MainTex.y + _Time.y * _FlowSpeedY));
            o.Albedo = c.rgb;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
