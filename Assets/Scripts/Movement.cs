using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class Movement : MonoBehaviour
{
    [Header("References")]
    [SerializeField] private Camera cam;
    [SerializeField] private Transform groundCheck;
    [SerializeField] private Transform cameraPosition;

    [Header("Settings")]
    [SerializeField] private float gravity = -9.81f;
    [SerializeField] private float groundDistance = 0.1f;
    [SerializeField] private LayerMask groundLayerMask;

    private CharacterController controller;
    private InputReading input;

    private float xRotation = 0.0f;
    private Vector3 velocity;
    private bool isGrounded;

    private void Awake()
    {
        TryGetComponent(out controller);
        TryGetComponent(out input);
    }

    private void OnEnable()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    private void OnDisable()
    {
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
    }

    private void Update()
    {
        cam.transform.position = cameraPosition.position;
        cam.transform.rotation = cameraPosition.rotation;

        isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, groundLayerMask);

        if (isGrounded && velocity.y < 0)
        {
            velocity.y = -1.0f;
        }

        transform.Rotate(Vector3.up * input.lookInput.x);

        xRotation -= input.lookInput.y;
        xRotation = Mathf.Clamp(xRotation, -90.0f, 90.0f);

        cameraPosition.localRotation = Quaternion.Euler(xRotation, transform.rotation.y, 0.0f);

        Vector3 moveDirection = transform.forward * input.walkInput.y + transform.right * input.walkInput.x;

        controller.Move(moveDirection * Time.deltaTime);

        velocity.y += gravity * Time.deltaTime;
        controller.Move(velocity * Time.deltaTime);
    }
}
