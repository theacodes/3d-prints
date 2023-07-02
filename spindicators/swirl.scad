linear_extrude(height=0.2) {
    scale([0.1, 0.1, 0.1]) {
        import(file="./swirl.dxf");
    }
}