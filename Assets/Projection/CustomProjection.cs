using UnityEngine;
using System.Collections;

public class CustomProjection : MonoBehaviour {

  void Start() {
    Camera camera = GetComponent<Camera> ();

    Matrix4x4 pers = PerspectiveProjection (camera);
    Matrix4x4 orth = OrthographicProjection (camera);

    //ShowProjectionMatrix ("Camera", camera.projectionMatrix);
    //ShowProjectionMatrix ("Custom Perspective", pers);
    //ShowProjectionMatrix ("Custom Orthographic", orth);

    Shader.SetGlobalMatrix ("_PersProj", GL.GetGPUProjectionMatrix(pers, false));
    Shader.SetGlobalMatrix ("_OrthProj", GL.GetGPUProjectionMatrix(orth, false));
  }

  void ShowProjectionMatrix(string name, Matrix4x4 mat) {
    Debug.Log (name);
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        Debug.Log (i + ", " + j + ": " +
          mat[i, j] + " >> " + 
          GL.GetGPUProjectionMatrix(mat, false)[i, j]
        );
      }
    }
  }

  Matrix4x4 PerspectiveProjection(Camera camera) {

    float near      = camera.nearClipPlane;
    float far       = camera.farClipPlane;

    float nearTop   = 1f / Mathf.Tan (camera.fieldOfView * 0.5f * Mathf.Deg2Rad);
    float nearRight = nearTop / camera.aspect;

    Matrix4x4 proj = new Matrix4x4();
    proj [0, 0] = nearRight;
    proj [0, 1] = 0f;
    proj [0, 2] = 0f;
    proj [0, 3] = 0f;

    proj [1, 0] = 0f;
    proj [1, 1] = nearTop;
    proj [1, 2] = 0f;
    proj [1, 3] = 0f;

    proj [2, 0] = 0f;
    proj [2, 1] = 0f;
    proj [2, 2] = -(far + near) / (far - near);
    proj [2, 3] = -(2f * far * near) / (far - near);

    proj [3, 0] = 0f;
    proj [3, 1] = 0f;
    proj [3, 2] = -1f;
    proj [3, 3] = 0f;

    return proj;
  }

  Matrix4x4 OrthographicProjection(Camera camera) {

    float near = camera.nearClipPlane;
    float far  = camera.farClipPlane;

    float dist = Mathf.Abs(camera.transform.position.z);
    float frustumHeight = 2f * dist * Mathf.Tan (camera.fieldOfView * 0.5f * Mathf.Deg2Rad);
    float frustumWidth = frustumHeight * camera.aspect;

    Matrix4x4 proj = new Matrix4x4();
    proj [0, 0] = 2f / frustumWidth;
    proj [0, 1] = 0f;
    proj [0, 2] = 0f;
    proj [0, 3] = 0f;

    proj [1, 0] = 0f;
    proj [1, 1] = 2f / frustumHeight;
    proj [1, 2] = 0f;
    proj [1, 3] = 0f;

    proj [2, 0] = 0f;
    proj [2, 1] = 0f;
    proj [2, 2] = -2f / (far - near);
    proj [2, 3] = -(far + near) / (far - near);

    proj [3, 0] = 0f;
    proj [3, 1] = 0f;
    proj [3, 2] = 0f;
    proj [3, 3] = 1f;

    return proj;
  }

}
