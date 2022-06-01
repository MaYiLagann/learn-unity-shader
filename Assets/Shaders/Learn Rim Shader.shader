Shader "Learn Unity Shader/Learn Rim"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based lambert lighting model, and enable shadows on all light types
        #pragma surface surf Lambert noambient

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

            o.Albedo = 0;
            o.Alpha = c.a;

            float rim = dot(o.Normal, IN.viewDir);
            o.Emission = pow(1 - rim, 3);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
