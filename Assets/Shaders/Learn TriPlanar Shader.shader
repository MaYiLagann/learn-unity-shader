Shader "Learn Unity Shader/Learn Triplanar"
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
            float3 worldPos;
            float3 worldNormal;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Create TriUV
            float2 topUV = float2 (IN.worldPos.x, IN.worldPos.z);
            float2 frontUV = float2 (IN.worldPos.x, IN.worldPos.y);
            float2 sideUV = float2 (IN.worldPos.z, IN.worldPos.y);

            // Textures
            fixed4 topTex = tex2D (_MainTex, topUV);
            fixed4 frontTex = tex2D (_MainTex, frontUV);
            fixed4 sideTex = tex2D (_MainTex, sideUV);

            fixed3 result = lerp(topTex, frontTex, abs(IN.worldNormal.z));
            result = lerp(result, sideTex, abs(IN.worldNormal.x));

            o.Albedo = result.rgb;
            o.Alpha = topTex.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
