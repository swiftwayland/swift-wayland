#include <termios.h>
#include <wayland-client.h>
#include <wayland-server.h>

struct wl_signal_container {
    void *instance;
    struct wl_listener listener;
};

struct wl_signal_container wl_signal_container_create() {
    struct wl_signal_container container;
    return container;
}

struct wl_signal_container* wl_signal_container_of(
    struct wl_listener *ptr
) {
    struct wl_signal_container *container =
        wl_container_of(ptr, container, listener);
    
    return container;
}

struct wl_listener_container {
    void *instance;
    struct wl_listener listener;
};

struct wl_listener_container* wl_listener_container_of(
    struct wl_listener *ptr
) {
    struct wl_listener_container *container =
        wl_container_of(ptr, container, listener);
    
    return container;
}
