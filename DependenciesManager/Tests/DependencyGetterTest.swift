import Testing
@testable import DependenciesManager

@MainActor
struct DependencyGetterTest {
    
    protocol SomeProtocol {
        func getString() -> String
    }
    
    class SomeProtocolImpl: SomeProtocol {
        func getString() -> String {
            return "Impl string"
        }
    }
    
    protocol AnotherProtocol {
        func getInt() -> Int
    }
    
    class AnotherProtocolImpl: AnotherProtocol {
        func getInt() -> Int {
            return 10
        }
    }
    
    let getter: DependencyGetterImpl
    
    init() {
        getter = DependencyGetterImpl(instances: [
            .factory(SomeProtocol.self) { _ in SomeProtocolImpl() },
            .factory(AnotherProtocol.self) { _ in AnotherProtocolImpl() },
        ])
    }
    
    @Test func shouldReturnImplementationOfProtocol() async throws {
        // when:
        let someProtocolInstance: SomeProtocol = getter.get()
        let anotherProtocolInstance: AnotherProtocol = getter.get()
        
        // then:
        #expect(someProtocolInstance.getString() == "Impl string")
        #expect(anotherProtocolInstance.getInt() == 10)
    }
}
