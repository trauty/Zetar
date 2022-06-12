using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputReading : MonoBehaviour
{
    [Header("Settings")]
    public float sensitivity = 10.0f;
    public float speed = 10.0f;

    private Controls controls;

    [HideInInspector] public Vector2 lookInput;
    [HideInInspector] public Vector2 walkInput;

    private void Awake()
    {
        controls = new Controls();
    }

    private void OnEnable()
    {
        controls.Enable();
    }

    private void OnDisable()
    {
        controls.Disable();
    }

    private void Update()
    {
        lookInput = controls.Main.Looking.ReadValue<Vector2>() * sensitivity;
        walkInput = controls.Main.Walking.ReadValue<Vector2>() * speed;
    }
}
