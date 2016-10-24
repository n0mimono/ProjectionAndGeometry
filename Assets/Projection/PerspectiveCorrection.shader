Shader "PerspectiveCorrection" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}

    [Toggle] _UseVertStageDivition ("Use Vertex Stage Division", Float) = 1
    [Toggle] _UsePerspectiveCorrection ("Use Perspective Correction", Float) = 1
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 100

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile_fog
      #include "UnityCG.cginc"

      sampler2D _MainTex;
      float4 _MainTex_ST;

      float _UseVertStageDivition;
      float _UsePerspectiveCorrection;

      struct appdata {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
      };

      struct v2f {
        float4 uv : TEXCOORD0;
        UNITY_FOG_COORDS(1)
        float4 vertex : SV_POSITION;
      };

      v2f vert (appdata v) {
        v2f o;

        float4x4 proj = proj = UNITY_MATRIX_P;
        float4x4 view  = UNITY_MATRIX_V;
        fixed4x4 vp    = mul(proj, view);

        o.vertex = mul(vp, mul(unity_ObjectToWorld, v.vertex));
        float w = o.vertex.w;

        o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
        o.uv.zw = 1;

        if (_UseVertStageDivition == 1) {
          o.vertex /= w;
          if (_UsePerspectiveCorrection) {
            o.uv /= w;
          }
        }

        UNITY_TRANSFER_FOG(o,o.vertex);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        if (_UseVertStageDivition == 1) {
          if (_UsePerspectiveCorrection) {
            i.uv /= i.uv.w;
          }
        }

        fixed4 col = tex2D(_MainTex, i.uv.xy);
        col.rgb = col.r > 0.99 ? 1 : 0;

        UNITY_APPLY_FOG(i.fogCoord, col);
        return col;
      }
      ENDCG
    }
  }
}
