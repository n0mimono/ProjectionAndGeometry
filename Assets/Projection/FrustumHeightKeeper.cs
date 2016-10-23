using UnityEngine;
using System.Collections;

public class FrustumHeightKeeper : MonoBehaviour {
  public float frustumHeight;

  void Start() {
    Camera camera = GetComponent<Camera> ();

    float dist = -1f * camera.transform.position.z;
    frustumHeight = 2f * dist * Mathf.Tan (camera.fieldOfView * 0.5f * Mathf.Deg2Rad);
  }

  void Update() {
    Camera camera = GetComponent<Camera> ();

    float dist = 0.5f * frustumHeight / Mathf.Tan (camera.fieldOfView * 0.5f * Mathf.Deg2Rad);

    Vector3 pos = camera.transform.position;
    pos.z = -1f * dist;
    camera.transform.position = pos;
  }

}
