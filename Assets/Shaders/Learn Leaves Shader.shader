Shader "Learn Unity Shader/Learn Leaves"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color ("Main Color", Color) = (1,1,1,1)
        _Cutoff ("Cutoff", float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }

        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff vertex:vert

        sampler2D _MainTex;
        float _Move;
        float _Timing;

        void vert(inout appdata_full v)
        {
            v.vertex.y += sin(_Time.y * 0.1);
        }

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}
