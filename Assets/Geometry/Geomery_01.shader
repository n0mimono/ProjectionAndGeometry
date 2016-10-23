Shader "Geometry_01" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 100

    Pass {
      CGPROGRAM
      #pragma target 4.0
      #pragma vertex vert
      #pragma geometry geo
      #pragma fragment frag
      #pragma multi_compile_fog
      #include "UnityCG.cginc"

      struct appdata {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
      };

      struct v2g {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;        
      };

      struct g2f {
        float2 uv : TEXCOORD0;
        UNITY_FOG_COORDS(1)
        float4 vertex : SV_POSITION;        
      };

      sampler2D _MainTex;
      float4 _MainTex_ST;
      
      v2g vert (appdata v) {
        v2g o;
        o.vertex = v.vertex;
        o.uv = v.uv;
        return o;
      }

      [maxvertexcount(3)]
      void geo(triangle v2g v[3], inout TriangleStream<g2f> TriStream) {
        for (int i = 0; i < 3; i++) {
          g2f o;
          o.vertex = mul(UNITY_MATRIX_MVP, v[i].vertex);
          o.uv = TRANSFORM_TEX(v[i].uv, _MainTex);
          UNITY_TRANSFER_FOG(o,o.vertex);
          TriStream.Append(o);
        }
      }

      fixed4 frag (g2f i) : SV_Target {
        fixed4 col = tex2D(_MainTex, i.uv);
        UNITY_APPLY_FOG(i.fogCoord, col);
        return col;
      }
      ENDCG
    }
  }
}
